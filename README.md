# FunctionalHash

`FunctionalHash` is a hash that allows you to set values as Procs that are called automatically when fetched with the square bracket syntax `[]`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'functional_hash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install functional_hash

## Usage

**Example: Set a hash value to be a function of others.**
```ruby
stats = FunctionalHash.new
stats[:batting_average] = -> (s) { (1.0 * s[:hits] / s[:at_bats]).round(3) }
stats[:at_bats] = 25
stats[:hits] = 10
stats[:batting_average]
# => 0.4
stats[:at_bats] += 1
stats[:batting_average]
# => 0.385 
stats[:at_bats] += 1
stats[:hits] += 1
stats[:batting_average]
 => 0.407
```


**Example: Set one hash value to be a function that takes additional parameters.**
```ruby
stats = FunctionalHash.new
stats[:batting_average] = -> (s, decimal_places) { (1.0 * s[:hits] / s[:at_bats]).round(decimal_places) }
stats[:at_bats] = 3
stats[:hits] = 1
stats[:batting_average, 6]
# => 0.333333
```

**Example: Set one hash value to be a function that takes parameters as options.**
```ruby
stats = FunctionalHash.new
stats[:batting_average] = -> (s, decimal_places:) { (1.0 * s[:hits] / s[:at_bats]).round(decimal_places) }
stats[:at_bats] = 3
stats[:hits] = 1
stats[:batting_average, decimal_places: 6]
# => 0.333333
```

**Example: Use functional hash values in other functional hash values.**
```ruby
stats = FunctionalHash.new
stats[:total_bases] = -> (s) { s[:singles] + 2 * s[:doubles] + 3 * s[:triples] + 4 * s[:homeruns] }
stats[:slugging_avg] = -> (s) { 1.0 * s[:total_bases] / s[:at_bats] }

stats[:singles] = 13
stats[:doubles] = 10
stats[:triples] = 2
stats[:homeruns] = 4
stats[:at_bats] = 90

stats[:slugging_avg].round(3)
# => 0.611

stats[:singles] += 1
stats[:at_bats] += 1

stats[:slugging_avg].round(3)
# => 0.615
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/afred/functional_hash.

