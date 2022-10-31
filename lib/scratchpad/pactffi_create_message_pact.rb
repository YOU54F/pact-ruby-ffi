require 'ffi'
require 'json'
require 'httparty'
require_relative 'PactFFILib'
include PactFFILib


puts 'Pact FFI version:'
puts PactFFILib.pactffi_version
ffi = PactFFILib
init = ffi.pactffi_init(PactFFILib::FfiLogLevel["LOG_LEVEL_TRACE"])
pact = ffi.pactffi_new_pact('http-consumer-2', 'http-provider')
# ffi.pactffi_logger_init()
ffi.pactffi_log_to_stdout(3)
ffi.pactffi_log_to_stderr(3)
ffi.pactffi_log_to_file('foo.log',5)
ffi.pactffi_logger_apply()
# ffi.pactffi_logger_apply()
ffi.pactffi_with_specification(pact, PactFFILib::FfiSpecificationVersion["SPECIFICATION_VERSION_V4"])
# ffi.pactffi_log_message('pact_ruby','INFO','woop')
interaction = ffi.pactffi_new_interaction(pact, 'A PUT request to generate book cover')
ffi.pactffi_upon_receiving(interaction, 'A PUT request to generate book cover')
ffi.pactffi_given(interaction, 'A book with id fb5a885f-f7e8-4a50-950f-c1a64a94d500 is required')
ffi.pactffi_with_request(interaction, 'PUT', '/api/books/fb5a885f-f7e8-4a50-950f-c1a64a94d500/generate-cover')
ffi.pactffi_with_header(interaction, 0, 'Content-Type', 0, 'application/json')
ffi.pactffi_with_body(interaction, 0, 'application/json', '[]')
ffi.pactffi_response_status(interaction, 204)
contents = {
  "uuid": {
      "pact:matcher:type": "regex",
      "regex": "^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$",
      "value": "fb5a885f-f7e8-4a50-950f-c1a64a94d500"
  }
}
length = JSON.dump(contents).length
size = length + 1
memBuf = FFI::MemoryPointer.new(:uint, length)
memBuf.put_bytes(0, JSON.dump(contents))
message_pact = ffi.pactffi_new_pact('message-consumer-2', 'message-provider')
message = ffi.pactffi_new_message(message_pact, 'Book (id fb5a885f-f7e8-4a50-950f-c1a64a94d500) created message')
ffi.pactffi_message_expects_to_receive(message, 'Book (id fb5a885f-f7e8-4a50-950f-c1a64a94d500) created message')
ffi.pactffi_message_given(message, 'A book with id fb5a885f-f7e8-4a50-950f-c1a64a94d500 is required')
ffi.pactffi_message_with_contents(message, 'application/json', memBuf, size)
port = ffi.pactffi_create_mock_server_for_pact(pact, '127.0.0.1:0', false)

if !PactFFILib.pactffi_mock_server_matched(port)
  puts 'No requests yet as expected'
else
  puts 'Hmm something smells a bit off.'
end

request1_done = false


puts "reify message"
reified = ffi.pactffi_message_reify(message)
puts "reified message"
puts JSON.pretty_generate(JSON.parse(reified))
puts JSON.parse(reified)["contents"]["uuid"]
options = {

  # body: {
  #   width: '720',
  #   height: "1080",
  # },
  body: [],
  params: {
    hostname: 'localhost',
    port: port,
    path: "/api/books/#{JSON.parse(reified)["contents"]["uuid"]}/generate-cover",
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json'
    }
  }
}
response = HTTParty.put("http://#{options[:params][:hostname]}:#{port}#{options[:params][:path]}", {
                          body: options[:body].to_json,
                          headers: { 'Content-Type' => 'application/json' }
                        })
if response.code == 204
  puts "request is ok: #{response.message}"
  puts response.body
  puts response.headers
  puts response.code
  request1_done = true
elsif response.code != 204
  puts "problem with request: #{response.message}"
  puts response
  request1_done = true
end

time = Time.now
sleep 2 and puts 'waiting for reqs' until Time.now > time + 1 || request1_done


if PactFFILib.pactffi_mock_server_matched(port)
  puts 'Mock server matched all requests, Yay!'
  file_pact = ffi.pactffi_write_pact_file(port, './pacts', false)
  puts file_pact
  file_message = ffi.pactffi_write_message_pact_file(message_pact, './pacts', false) # this isnt writing
  puts file_message
  PactFFILib.pactffi_cleanup_mock_server(port)
  exit
else
  puts 'Pact consumer verification failed!'
  mismatch_json = PactFFILib.pactffi_mock_server_mismatches(port)
  puts JSON.pretty_generate(JSON.parse(mismatch_json))
  PactFFILib.pactffi_cleanup_mock_server(port)
  exit!
end

