# -*- ruby -*-
# encoding: utf-8

Gem::Specification.new do |s|
  s.name          = 'avro-ruby'
  s.version       = '1.0.0'
  s.authors       = ['Yousaf Nabi']
  s.email         = 'you@saf.dev'
  s.homepage      = 'https://github.com/you54f'
  s.summary       = 'Avro Ruby overview sample'
  s.description   = 'Simple demo of using Avro from Ruby'

  s.files         = `git ls-files -- *`.split("\n")
  s.executables   = `git ls-files -- area_calculator*.rb`.split("\n").map do |f|
    File.basename(f)
  end
  s.require_paths = ['lib']
  s.platform      = Gem::Platform::RUBY

  s.add_development_dependency 'bundler', '>= 1.9'
end