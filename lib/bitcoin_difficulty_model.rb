require 'bitcoin_difficulty_model/version'
require 'bitcoin_difficulty_model/blocks_import'
require 'bitcoin_difficulty_model/forecast'

module BitcoinDifficultyModel

  def self.forecast(blocks, investment_horizon, monthly_growth = nil)
    forecast = Forecast.new(blocks, investment_horizon, monthly_growth)
    forecast.perform
  end

  def self.calc_time_per_block(difficulty, hashrate)
    target = 0x00000000ffff0000000000000000000000000000000000000000000000000000 / difficulty
    return 2 ** 256/(target*hashrate*10**9)
  end

end
