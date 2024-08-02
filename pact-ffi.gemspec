lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'pact-ffi'
  spec.version       = '0.4.22'
  spec.authors       = ['Yousaf Nabi']
  spec.email         = ['you@saf.dev']
  spec.summary       = 'Pact Reference FFI libpact_ffi library wrapper'
  spec.description   = 'Enables consumer driven contract testing, providing a mock service and DSL for the consumer project, and interaction playback and verification for the service provider project.'
  spec.homepage      = 'https://github.com/you54f/pact-ffi'
  spec.license       = 'MIT'
  spec.files         = `git ls-files bin lib pact.gemspec CHANGELOG.md LICENSE.txt README.md`.split($/)
  spec.require_paths = ['lib']
  # spec.add_development_dependency 'bundler', '~> 2.4'
  spec.add_development_dependency 'cucumber', '~> 9.2'
  spec.add_development_dependency 'httparty', '~> 0.21.0'
  spec.add_development_dependency 'nokogiri', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webrick', '~> 1.8'
  spec.add_dependency 'ffi', '~> 1.15'
end
