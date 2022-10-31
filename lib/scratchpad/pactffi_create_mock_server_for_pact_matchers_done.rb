require 'ffi'
require 'json'
require 'httparty'
require_relative 'PactFFILib.rb'
include PactFFILib


puts 'Pact FFI version:'
puts PactFFILib.pactffi_version
ffi = PactFFILib
init = ffi.pactffi_init('LOG_LEVEL')
pact = ffi.pactffi_new_pact('http-consumer-1', 'http-provider')
ffi.pactffi_with_specification(pact, 3)
interaction = ffi.pactffi_new_interaction(pact, 'A POST request to create book')
ffi.pactffi_upon_receiving(interaction, 'A POST request to create book')
ffi.pactffi_given(interaction, 'No book fixtures required')
ffi.pactffi_with_request(interaction, 'POST', '/api/books')
ffi.pactffi_with_header(interaction, 0, 'Content-Type', 0, 'application/json')
pact_data = '{
  "isbn": {
      "pact:matcher:type": "type",
      "value": "0099740915"
  },
  "title": {
      "pact:matcher:type": "type",
      "value": "The Handmaid\'s Tale"
  },
  "description": {
      "pact:matcher:type": "type",
      "value": "Brilliantly conceived and executed, this powerful evocation of twenty-first century America gives full rein to Margaret Atwood\'s devastating irony, wit and astute perception."
  },
  "author": {
      "pact:matcher:type": "type",
      "value": "Margaret Atwood"
  },
  "publicationDate": {
      "pact:matcher:type": "regex",
      "regex": "^\\\\d{4}-[01]\\\\d-[0-3]\\\\dT[0-2]\\\\d:[0-5]\\\\d:[0-5]\\\\d([+-][0-2]\\\\d:[0-5]\\\\d|Z)$",
      "value": "1985-07-31T00:00:00+00:00"
  }
}'
ffi.pactffi_with_body(interaction, 0, 'application/json', pact_data)
ffi.pactffi_response_status(interaction, 201)
ffi.pactffi_with_header(interaction, 1, 'Content-Type', 0, 'application/ld+json; charset=utf-8');
pact_file_two = '{
  "@context": "/api/contexts/Book",
  "@id": {
      "pact:matcher:type": "regex",
      "regex": "^\\\\/api\\\\/books\\\\/[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$",
      "value": "/api/books/0114b2a8-3347-49d8-ad99-0e792c5a30e6"
  },
  "@type": "Book",
  "title": {
      "pact:matcher:type": "type",
      "value": "Voluptas et tempora repellat corporis excepturi."
  },
  "description": {
      "pact:matcher:type": "type",
      "value": "Quaerat odit quia nisi accusantium natus voluptatem. Explicabo corporis eligendi ut ut sapiente ut qui quidem. Optio amet velit aut delectus. Sed alias asperiores perspiciatis deserunt omnis. Mollitia unde id in."
  },
  "author": {
      "pact:matcher:type": "type",
      "value": "Melisa Kassulke"
  },
  "publicationDate": {
      "pact:matcher:type": "regex",
      "regex": "^\\\\d{4}-[01]\\\\d-[0-3]\\\\dT[0-2]\\\\d:[0-5]\\\\d:[0-5]\\\\d([+-][0-2]\\\\d:[0-5]\\\\d|Z)$",
      "value": "1999-02-13T00:00:00+07:00"
  },
  "reviews": [

  ]
}'
ffi.pactffi_with_body(interaction, 1, 'application/ld+json; charset=utf-8', pact_file_two)
port = ffi.pactffi_create_mock_server_for_pact(pact, '127.0.0.1:0', false)

## start our mock server which we can load with a pact_file
# puts 'pactffi_create_mock_server call to start'
# port = PactFFILib.pactffi_create_mock_server(pact_file, '127.0.0.1:0')
# puts "Mock server port=#{port}"

if !PactFFILib.pactffi_mock_server_matched(port)
  puts 'No requests yet as expected'
else
  puts 'Hmm something smells a bit off.'
end

request1_done = false

options = {

  body: {
    isbn: '0099740915',
    title: "The Handmaid's Tale",
    description: 'Brilliantly conceived and executed, this powerful evocation of twenty-first century America gives full rein to Margaret Atwood\'s devastating irony, wit and astute perception.',
    author: 'Margaret Atwood',
    publicationDate: '1985-07-31T00:00:00+00:00'
  },
  # body: {
  #   isbn: '0099740915',
  #   title: 123,
  #   description: 'Natus ut doloribus magni. Impedit aperiam ea similique. Sed architecto quod nulla maxime. Quibusdam inventore esse harum accusantium rerum nulla voluptatem.',
  #   author: 'Maryse Kulas',
  #   publicationDate: 'tommorow'
  # },
  params:{
    hostname: 'localhost',
    port: port,
    path: '/api/books',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    }}
}
response = HTTParty.post("http://#{options[:params][:hostname]}:#{port}#{options[:params][:path]}", {
                           body: options[:body].to_json,
                           headers: { 'Content-Type' => 'application/json' }
                         })
if response.code == 200
  puts "request is ok: #{response.message}"
  puts response.body
  request1_done = true
elsif response.code != 201
  puts "problem with request: #{response.message}"
  request1_done = true
end

time = Time.now
sleep 2 and puts 'waiting for reqs' until Time.now > time + 1 || request1_done

if PactFFILib.pactffi_mock_server_matched(port)
  puts 'Mock server matched all requests, Yay!'
  file = ffi.pactffi_write_pact_file(port, './pact', false)
  puts file
  PactFFILib.pactffi_cleanup_mock_server(port)
  exit
else
  puts 'Pact provider verification failed!'
  mismatch_json = PactFFILib.pactffi_mock_server_mismatches(port)
  puts JSON.pretty_generate(JSON.parse(mismatch_json))
  PactFFILib.pactffi_cleanup_mock_server(port)
  exit!
end