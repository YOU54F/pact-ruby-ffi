
require 'ffi'
require 'json'
require 'httparty'
require_relative 'PactFFILib.rb'
include PactFFILib



puts 'Pact FFI version:'
puts PactFFILib.pactffi_version
ffi = PactFFILib
verifier = ffi.pactffi_verifier_new_for_application('pact-ruby','1.0.0')

ffi.pactffi_verifier_set_provider_info(verifier,'provider-name','','localhost',8080,'/')
ffi.pactffi_verifier_add_file_source(verifier,'/Users/saf/dev/pact-foundation/pact-reference/ruby/ruby_ffi/pact/http-consumer-1-http-provider.json')
result = ffi.pactffi_verifier_execute(verifier)
time = Time.now
sleep 5 and puts 'waiting for reqs' until Time.now > time + 1 || result == 0


if !result == 0
  puts "We are winning!\n"
  puts result
  puts ffi.pactffi_verifier_logs(verifier)
  ffi.pactffi_verifier_shutdown(verifier)
  exit!
else
  puts "We got some problems, Boo!\n"
  puts result
  puts ffi.pactffi_verifier_logs(verifier)
  ffi.pactffi_verifier_shutdown(verifier)
  exit
end