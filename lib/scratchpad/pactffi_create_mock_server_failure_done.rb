require 'ffi'
require 'json'
require 'httparty'
require_relative 'PactFFILib.rb'
include PactFFILib

pact_file = '{
  "provider": {
    "name": "test_provider"
  },
  "consumer": {
    "name": "test_consumer"
  },
  "interactions": [
    {
      "providerState": "test state",
      "description": "test interaction",
      "request": {
        "method": "POST",
        "path": "/",
        "body": {
          "complete": {
            "certificateUri": "http://...",
            "issues": {
              "idNotFound": {}
            },
            "nevdis": {
              "body": null,
              "colour": null,
              "engine": null
            },
            "body": 123456
          },
          "body": [
            1,
            2,
            3
          ]
        }
      },
      "response": {
        "status": 200
      }
    }
  ],
  "metadata": {
    "pact-specification": {
      "version": "2.0.0"
    },
    "pact-jvm": {
      "version": ""
    }
  }
}'

puts 'pactffi_create_mock_server call to start'
port = PactFFILib.pactffi_create_mock_server(pact_file, '127.0.0.1:0')
puts "Mock server port=#{port}"

if !PactFFILib.pactffi_mock_server_matched(port)
  puts 'No requests yet, as expected'
else
  puts 'Hmm, something smells a bit off.'
end

options = {
  hostname: 'localhost',
  port: port,
  path: '/',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  }
}

body = {
  "complete": {
    "certificateUri": 'http://...',
    "issues": {},
    "nevdis": {
      "body": 'red',
      "colour": nil,
      "engine": nil
    },
    "body": '123456'
  },
  "body": [1, 3]
}

request1_done = false
request2_done = false

response = HTTParty.post("http://#{options[:hostname]}:#{options[:port]}#{options[:path]}", { options: { body: body } })
if response.code == 200
  puts "request is ok: #{response.message}"
  puts response.body
elsif response.code != 200
  puts "problem with request: #{response.message}"
  request1_done = true
end

options_2 = {
  hostname: 'localhost',
  port: port,
  path: '/mallory',
  method: 'PUT',
  headers: {
    'Content-Type': 'application/json'
  }
};

response = HTTParty.put("http://#{options_2[:hostname]}:#{options_2[:port]}#{options_2[:path]}", { options: { body: {} } })
if response.code == 200
  puts "request is ok: #{response.message}"
  puts response.body
elsif response.code != 200
  puts "problem with request: #{response.message}"
  request1_done = true
end


time = Time.now
sleep 2 and puts 'waiting for reqs' until Time.now > time + 1 || request1_done && request2_done

if PactFFILib.pactffi_mock_server_matched(port)
  puts '"Mock server matched all requests, That Is Not Good (tm)'
else
  mismatch_json = PactFFILib.pactffi_mock_server_mismatches(port)
  puts JSON.pretty_generate(JSON.parse(mismatch_json))
  puts 'We got some mismatches, as expected.'
end

# puts 'calling pactffi_cleanup_mock_server'
PactFFILib.pactffi_cleanup_mock_server(port)
# puts 'cleaned pactffi_create_mock_server'
