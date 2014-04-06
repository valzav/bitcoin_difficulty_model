# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bitcoin_difficulty_model/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Valentine Zavgorodnev"]
  gem.email         = ["vz@valzav.com"]
  gem.description   = %q{This model forecasts Bitcoin network difficulty on a day by day basis using historical difficulty/hash rate data and monthly growth rate as inputs.}
  gem.summary       = %q{Bitcoin Network Difficulty Model}
  gem.homepage      = "https://github.com/valzav/bitcoin_difficulty_model"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bitcoin_difficulty_model"
  gem.require_paths = ["lib"]
  gem.version       = BitcoinDifficultyModel::VERSION
  gem.add_runtime_dependency 'curb'
end
