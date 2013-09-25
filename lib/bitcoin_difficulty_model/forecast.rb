module BitcoinDifficultyModel

  class Forecast

    attr_accessor :blocks, :horizon_date

    def initialize(blocks, investment_horizon, monthly_growth)
      @blocks = blocks.clone
      @investment_horizon, @monthly_growth = investment_horizon, monthly_growth
      @forecast_from_days_ago = 0 # might be useful when we want to compare forecast with real historical data
    end

    def perform
      res = {}
      @monthly_growth ||= get_average_monthly_growth(@blocks, 30)
      res[:monthly_growth] = @monthly_growth

      dr = (1.0 + @monthly_growth.to_f / 100.0) ** (1.0 / 30.0) - 1
      start_index = find_start_index(@blocks) # we want to start from last difficulty change
      res[:cur_speed] = cur_ghps = get_last_5_points_avg_ghps(@blocks, start_index)
      res[:cur_difficulty] = cur_difficulty = @blocks.at(start_index).difficulty

      prolong(@blocks, @investment_horizon)
      res[:horizon_date] = @horizon_date

      blocks_counter = 0.0
      counter = 0
      time_per_block_sum = 0.0

      (start_index..@blocks.length-1).each do |i|
        b = @blocks.at(i)
        cur_ghps = cur_ghps + cur_ghps * dr
        b.f_ghps = cur_ghps
        time_per_block = BitcoinDifficultyModel.calc_time_per_block(cur_difficulty, b.ghps || cur_ghps)
        time_per_block_sum += time_per_block
        blocks_per_day = 86400.0/time_per_block
        blocks_counter += blocks_per_day
        counter += 1
        if blocks_counter >= 2016.0
          time_per_block_avg = time_per_block_sum/counter
          new_difficulty = cur_difficulty * 600.0 / time_per_block_avg
          cur_difficulty = new_difficulty
          time_per_block_sum = 0.0
          counter = 0
          blocks_counter = blocks_counter - 2016.0
        end
        b.f_difficulty = cur_difficulty
      end
      res[:blocks] = @blocks
      return res
    end

    private

    def get_average_monthly_growth(blocks, days_back)
      ghps_delta = 0.0
      deltas_counter = 0
      prev_ghps = nil
      len = blocks.length - @forecast_from_days_ago
      start_index = len - days_back
      blocks.each_with_index do |b, i|
        next if i < start_index
        if prev_ghps
          ghps_delta += (b.ghps - prev_ghps)/prev_ghps
          deltas_counter += 1
        end
        prev_ghps = b.ghps
      end
      rd = ghps_delta/deltas_counter
      rm = ((rd+1)**30-1)*100.0
      return rm
    end

    def get_last_5_points_avg_ghps(blocks, start_index)
      sum = 0.0
      (start_index-4..start_index).each do |i|
        sum += blocks.at(i).ghps
      end
      sum/5.0
    end

    # finds last difficulty adjustment day
    def find_start_index(blocks)
      difficulty = blocks.last.difficulty
      start_index = @forecast_from_days_ago
      blocks.reverse.each_with_index do |rb, i|
        if i < start_index
          difficulty = rb.difficulty
          next
        end
        if rb.difficulty != difficulty
          start_index = i
          break
        end
      end
      blocks.length - start_index
    end

    def prolong(blocks, investment_horizon)
      date = blocks.last.date
      @horizon_date = date
      (1..investment_horizon.to_i).to_a.each { @horizon_date = @horizon_date.next_month }
      (0..365).each do
        date += 1
        blocks << Block.new(0, date, date.to_time, nil, nil)
        break if date >= @horizon_date
      end
    end

  end

end
