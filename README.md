# BitcoinDifficultyModel

This model forecasts Bitcoin network difficulty on a day by day basis using historical difficulty/hash rate data and monthly growth rate as inputs.

There is also an example of Bitcoin mining calculator that utilizes the model.

This is a spin-off of my work on http://www.bitreturn.com.

## Installation

Build and install bitcoin_difficulty_model gem into system gems:

    $ rake install

Add this line to your application's Gemfile:

    gem 'bitcoin_difficulty_model'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitcoin_difficulty_model

## Usage

Take a look at usage example in bin/bitcoin_mining_calc.rb.
Please note that when you create BitcoinDifficultyModel::BlocksImport with default arguments,
it will download historical data from http://blockexplorer.com/q/nethash, you may want to cache this data
locally and pass local file url (file:///..) into BlocksImport constructor.

## Running Tests Suite

    $ rake test

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
