lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pact_ruby_ffi/version'

Gem::Specification.new do |spec|
  spec.name          = 'pact_ruby_ffi'
  spec.version       = PactRubyFfi::VERSION
  spec.authors       = ['Yousaf Nabi']
  spec.email         = ['you@saf.dev']

  spec.summary       = 'pact-ruby-ffi'
  spec.description   = 'pact-ruby-ffi'
  spec.homepage      = 'https://github.com/you54f/pact_ruby_ffi'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|pact|pacts)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'httparty', '~> 0.17.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'ffi', '~> 1.15'
end
