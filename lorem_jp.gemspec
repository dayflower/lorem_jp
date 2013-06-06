# -*- coding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name          = 'lorem_jp'
  spec.version       = '0.0.1'
  spec.authors       = ['ITO Nobuaki']
  spec.email         = ['daydream.trippers@gmail.com']
  spec.description   = %q{Japanese Lorem Ipsum generator}
  spec.summary       = %q{Japanese Lorem Ipsum generator}
  spec.homepage      = 'https://github.com/dayflower/lorem_jp/'
  spec.license       = 'MIT'

  spec.files         = [
    'lorem_jp.gemspec',
    'Gemfile',
    'Rakefile',
    'LICENSE.txt',
    'README.md',
    'lib/lorem_jp.rb',
    'lib/lorem_jp/cli.rb',
    'data/dict.txt',
    'bin/lorem_jp',
    'build/make_dict.rb',
    'build/fetcher.rb',
    'build/recipes/789.rb',
    'build/recipes/2363.rb',
    'build/recipes/52960.rb',
    'test/lorem_jp_spec.rb',
  ]

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
