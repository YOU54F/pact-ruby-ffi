# -*- ruby -*-
# encoding: utf-8

Gem::Specification.new do |s|
  s.name          = 'grpc-demo'
  s.version       = '1.0.0'
  s.authors       = ['gRPC Authors']
  s.email         = 'temiola@google.com'
  s.homepage      = 'https://github.com/grpc/grpc'
  s.summary       = 'gRPC Ruby overview sample'
  s.description   = 'Simple demo of using gRPC from Ruby'

  s.files         = `git ls-files -- *`.split("\n")
  s.executables   = `git ls-files -- area_calculator*.rb`.split("\n").map do |f|
    File.basename(f)
  end
  s.require_paths = ['lib','../../lib']
  s.platform      = Gem::Platform::RUBY

  s.add_dependency 'google-protobuf', '~> 3.25'
  s.add_dependency 'grpc', '~> 1.6'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_dependency 'multi_json', '~> 1.15'
  s.add_development_dependency 'bundler', '>= 2.3'
  s.add_development_dependency 'pact-ffi', '>= 0.1.0'
end