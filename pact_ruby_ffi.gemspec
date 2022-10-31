# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pact_ruby_ffi/version"

Gem::Specification.new do |spec|
  spec.name          = "pact_ruby_ffi"
  spec.version       = PactRubyFfi::VERSION
  spec.authors       = ["Yousaf Nabi"]
  spec.email         = ["you@saf.dev"]

  spec.summary       = "pact-ruby-ffi"
  spec.description   = "pact-ruby-ffi"
  spec.homepage      = "https://saf.dev"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://mygemserver.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "ffi", "~> 1.15"
end
