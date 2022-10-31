require 'ffi'
require 'json'
require 'httparty'
require_relative '../pact_ruby_ffi.rb'
# require 'pact_ruby_ffi'
include PactRubyFfi

pact_file = '{
    "provider": {
      "name": "Alice Service"
    },
    "consumer": {
      "name": "Consumer"
    },
    "interactions": [
      {
        "description": "a retrieve Mallory request",
        "request": {
          "method": "GET",
          "path": "/mallory",
          "query": "name=ron&status=good"
        },
        "response": {
          "status": 200,
          "headers": {
            "Content-Type": "text/html"
          },
          "body": "That is some good Mallory."
        }
      }
    ],
    "metadata": {
      "pact-specification": {
        "version": "1.0.0"
      },
      "pact-jvm": {
        "version": "1.0.0"
      }
    }
  }'
puts 'pactffi_create_mock_server call to start'
ffi = PactRubyFfi
port = ffi.pactffi_create_mock_server(pact_file, '127.0.0.1:0')
#  * Initialises logging, and sets the log level explicitly. This function should only be called
#  * once, as it tries to install a global tracing subscriber.
# ffi.pactffi_init_with_log_level(ffi::FfiLogLevel["LOG_LEVEL_INFO"])
ffi.pactffi_logger_init
ffi.pactffi_logger_attach_sink('file ./pact/logs/log.txt', ffi::FfiLogLevelFilter["LOG_LEVEL_INFO"])
ffi.pactffi_logger_apply
puts "Mock server port=#{port}"

if !ffi.pactffi_mock_server_matched(port)
  puts 'No requests yet as expected'
else
  puts 'Hmm something smells a bit off.'
end
response = HTTParty.get("http://localhost:#{port}/mallory?name=ron&status=good")
puts response.body if response.code == 200
if ffi.pactffi_mock_server_matched(port)
  puts 'Mock server matched all requests, Yay!'
else
  puts 'We got some mismatches, Boo!'
end

puts 'calling pactffi_cleanup_mock_server'
ffi.pactffi_cleanup_mock_server(port)
puts 'cleaned pactffi_create_mock_server'
