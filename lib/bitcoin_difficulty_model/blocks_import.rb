require 'date'
require 'curb'
require_relative './block'

module BitcoinDifficultyModel

  class BlocksImport

    def initialize(url = 'http://blockexplorer.com/q/nethash', start_from_block = 0)
      @last_block_number = start_from_block
      @last_block_date = Date.new(0)
      @curl = Curl::Easy.new
      @curl.follow_location = true
      @curl.max_redirects = 3
      @curl.useragent = 'BitReturn/1.0'
      @curl.url = url
    end

    def each_block
      @curl.perform
      data = @curl.body_str
      start = false
      for_each_line_in(data) do |l|
        if l == 'START DATA'
          start = true
          next
        end
        next unless start
        block = parse_csv_line(l)
        next if block.number <= @last_block_number or block.date <= @last_block_date
        @last_block_number = block.number
        @last_block_date = block.date
        yield block
      end
    end

    private

      def parse_csv_line(l)
        # blockNumber,time,target,avgTargetSinceLast,difficulty,hashesToWin,avgIntervalSinceLast,netHashPerSecond
        data = l.strip.split(',')
        block_time = Time.at(data[1].to_i)
        Block.new(data[0].to_i, block_time.to_date, block_time, data[4].to_f, data[7].to_f / 1000000000.0)
      end

      def for_each_line_in(data)
        line = ''
        for i in 0..(data.length-1)
          c = data[i]
          if c == "\n"
            yield line
            line = ''
          else
            line << c
          end
        end
        yield line unless line.empty?
      end

  end

end
