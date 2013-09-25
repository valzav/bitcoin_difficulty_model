#!/usr/bin/env ruby

$LOAD_PATH << '/home/vz/work/bitcoin_difficulty_model/lib'
require 'bitcoin_difficulty_model'
#require_relative '../lib/bitcoin_difficulty_model'

@investment_horizon = 6 # 6 months
@monthly_growth_rate = 60 # 60%
@miner_speed = 100 # 100 Gh/s
@start_date = Date.today

blocks = []
import = BitcoinDifficultyModel::BlocksImport.new
import.each_block do |block|
  blocks << block
end
res = BitcoinDifficultyModel.forecast(blocks, @investment_horizon, @monthly_growth_rate)

btc_sum = 0.0
days = 0
res[:blocks].each do |b|
  next if b.date < @start_date
  days += 1
  difficulty = b.difficulty || b.f_difficulty
  time_per_block = BitcoinDifficultyModel.calc_time_per_block(difficulty, @miner_speed)
  blocks_per_24h = 24*3600/time_per_block
  btc_per_24h = blocks_per_24h * 25
  btc_sum += btc_per_24h
end
puts "#{@miner_speed} Gh/s miner yields #{btc_sum.round(2)} in #{days} days starting from #{@start_date}"
# please note result doesn't include electricity cost and pool fee
