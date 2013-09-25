require 'test/unit'
require 'bitcoin_difficulty_model'

class BitcoinDifficultyModelTest < Test::Unit::TestCase

  def setup
    @investment_horizon = 6 # 6 months
    @monthly_growth_rate = 60 # 60%
  end

  def test_forecast
    blocks = []
    import = BitcoinDifficultyModel::BlocksImport.new
    import.each_block do |block|
      blocks << block
    end
    len1 = blocks.length
    res = BitcoinDifficultyModel.forecast(blocks, @investment_horizon, @monthly_growth_rate)
    len2 = res[:blocks].length
    assert len2 > len1 + @investment_horizon*30
    assert len2 < len1 + (@investment_horizon+1)*31
  end

end
