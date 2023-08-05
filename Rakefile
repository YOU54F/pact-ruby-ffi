require 'rspec/core/rake_task'
require 'rubygems/package'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

## Supportable platforms with FFI

# aarch64-linux
# arm64-darwin
# x64-mingw-ucrt
# x86_64-darwin
# x86_64-linux

## Additional platforms supported by Nokogiri

# arm-linux
# x86-linux
# x86-mingw32

PLATFORMS = [
  {
    ruby_platform: 'aarch64-linux',
    ffi_location: 'linux-arm64',
    ffi_name: 'libpact_ffi.so'
  },
  {
    ruby_platform: 'arm64-darwin',
    ffi_location: 'macos-arm64',
    ffi_name: 'libpact_ffi.dylib'
  },
  {
    ruby_platform: 'x86_64-linux',
    ffi_location: 'linux-x64',
    ffi_name: 'libpact_ffi.so'
  },
  {
    ruby_platform: 'x86_64-darwin',
    ffi_location: 'macos-x64',
    ffi_name: 'libpact_ffi.dylib'
  },
  {
    ruby_platform: 'x64-mingw-ucrt',
    ffi_location: 'windows-x64',
    ffi_name: 'pact_ffi.dll'
  }
  #   {
  #     ruby_platform: 'arm-linux',
  #     ffi_location: 'linux-arm',
  #     ffi_name: 'libpact_ffi.so'
  #   },
  #   {
  #     ruby_platform: 'x86-linux',
  #     ffi_location: 'linux-x86',
  #     ffi_name: 'libpact_ffi.so'
  #   },
  #   {
  #     ruby_platform: 'x86-mingw32',
  #     ffi_location: 'windows-x86',
  #     ffi_name: 'pact_ffi.dll'
  #   }
]
task :build do
  gemspec = Gem::Specification.load('pact-ffi.gemspec')
  sh 'mkdir -p pkg'
  PLATFORMS.each do |platform|
    platform_gemspec = gemspec.clone
    puts platform_gemspec
    platform_gemspec.files.push(['ffi', platform[:ffi_location], platform[:ffi_name]].join('/'))
    puts platform_gemspec.name
    puts platform_gemspec.files
    platform_gemspec.platform = platform[:ruby_platform]
    Gem::Package.build(platform_gemspec)
    sh "mv #{platform_gemspec.name}-#{platform_gemspec.version}-#{platform[:ruby_platform]}.gem pkg/"
  end
end

task :clean do
  sh 'rm -rf pkg'
end

task :yank do
  sh 'gem yank pact-ffi -v 0.0.1 --platform aarch64-linux'
  sh 'gem yank pact-ffi -v 0.0.1 --platform arm64-darwin'
  sh 'gem yank pact-ffi -v 0.0.1 --platform x64-mingw-ucrt'
  sh 'gem yank pact-ffi -v 0.0.1 --platform x86_64-darwin'
  sh 'gem yank pact-ffi -v 0.0.1 --platform x86_64-linux'
end

task :push do
  sh 'cd pkg && gem push pact-ffi-0.0.3-aarch64-linux.gem'
  sh 'cd pkg && gem push pact-ffi-0.0.3-arm64-darwin.gem'
  sh 'cd pkg && gem push pact-ffi-0.0.3-x64-mingw-ucrt.gem'
  sh 'cd pkg && gem push pact-ffi-0.0.3-x86_64-darwin.gem'
  sh 'cd pkg && gem push pact-ffi-0.0.3-x86_64-linux.gem'
end
