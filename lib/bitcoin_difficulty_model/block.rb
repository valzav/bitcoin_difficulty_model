module BitcoinDifficultyModel

  class Block
    attr_accessor :number, :date, :time, :difficulty, :ghps, :f_difficulty, :f_ghps

    def initialize(number, date, time, difficulty, ghps)
      @number, @date, @time, @difficulty, @ghps = number, date, time, difficulty, ghps
    end

    def attrs
      {number: @number, date: @date, difficulty: @difficulty ? @difficulty : @f_difficulty, ghps: @ghps ? @ghps : @f_ghps}
    end
  end

end
