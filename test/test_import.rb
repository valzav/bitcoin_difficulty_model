require 'test/unit'
require 'bitcoin_difficulty_model'

class BitcoinDifficultyModelTest < Test::Unit::TestCase

  def test_import
    import = BitcoinDifficultyModel::BlocksImport.new
    counter = 0
    last_difficulty = 0
    import.each_block do |block|
      counter += 1
      last_difficulty = block.difficulty
    end
    assert counter >= 1555
    assert last_difficulty >= 112628548.66
  end

end
