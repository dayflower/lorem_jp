# LoremJP

Japanese Lorem Ipsum generator.

## Usage

```ruby
# Singleton API
LoremJP.sentence        # => meaningless Japanese sentence

# Or create an instance and re-use it
generator = LoremJP.new
generator.sentence      # => ...
generator.sentence      # => ...
```

## Installation

Add this line to your application's Gemfile:

    gem 'lorem_jp', :github => 'dayflower/lorem_jp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lorem_jp

## TODO

* write document
* write tests

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
