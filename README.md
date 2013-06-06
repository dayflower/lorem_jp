# LoremJP

Japanese Lorem Ipsum generator.

## Usage

```ruby
# Singleton API
puts LoremJP.sentence   # => output meaningless Japanese sentence

# Or create an instance and re-use it
generator = LoremJP.new
generator.sentence      # => ...
generator.sentence      # => ...
```

Command line tool `lorem_jp` is also available.

    $ lorem_jp
    blah blah blah ...

## Installation

Add this line to your application's Gemfile:

    gem 'lorem_jp', :github => 'dayflower/lorem_jp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lorem_jp

## Notice

Default dictionary is assembled from out-of-copyright texts provided by [Aozora Bunko](http://www.aozora.gr.jp/index.html).

* "[Chawan no yu](http://www.aozora.gr.jp/cards/000042/card2363.html)"
  by "[Torahiko Terada](http://www.aozora.gr.jp/index_pages/person42.html)"
* "[Akai fune no okyaku](http://www.aozora.gr.jp/cards/001475/card52960.html)"
  by "[Mimei Ogawa](http://www.aozora.gr.jp/index_pages/person1475.html)"

## TODO

* write document for usage (in README)
* write document for building custom dictionary
* write more tests

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
