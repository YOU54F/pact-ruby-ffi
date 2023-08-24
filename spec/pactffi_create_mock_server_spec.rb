require 'httparty'
# require 'pact/ffi'
require 'pact/ffi/logger'
require 'pact/ffi/mock_server'
require 'fileutils'

PactFfi::Logger.log_to_buffer(PactFfi::Logger::LogLevel['ERROR'])
RSpec.describe 'pactffi_create_mock_server spec' do
  describe 'with matching requests' do
    let(:pact) do
      '
      {
        "provider": {
          "name": "Alice Service"
        },
        "consumer": {
          "name": "Consumer-pact-ruby-ffi"
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
      }
      '
    end

    let(:mock_server_port) { PactFfi::MockServer.create(pact, '127.0.0.1:4432',false) }

    after do
      expect(PactFfi::MockServer.matched(mock_server_port)).to be true
      res_write_pact = PactFfi::MockServer.write_pact_file(mock_server_port, './pacts', false)
      PactFfi::MockServer.cleanup(mock_server_port)
      expect(res_write_pact).to be(0)
    end

    it 'executes the pact test with no errors' do
      puts "Mock server port=#{mock_server_port}"

      response = HTTParty.get("http://127.0.0.1:#{mock_server_port}/mallory?name=ron&status=good")

      expect(response.body).to eq 'That is some good Mallory.'
    end
  end

  describe 'with mismatching requests' do
    let(:pact) do
      '
      {
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
      }
      '
    end

    # this fails in CI as http client cannot connect to mock server
    let(:mock_server_port) { PactFfi::MockServer.create(pact, '0.0.0.0:0',false) }

    after do
      expect(PactFfi::MockServer.matched(mock_server_port)).to be false
      mismatchers = PactFfi::MockServer.mismatches(mock_server_port)
      puts JSON.parse(mismatchers)
      expect(JSON.parse(mismatchers).length).to eql(2)
      PactFfi::MockServer.cleanup(mock_server_port)
    end

    it 'returns the mismatches' do
      puts "Mock server port=#{mock_server_port}"

      expect(PactFfi::MockServer.matched(mock_server_port)).to be false

      response1 = HTTParty.post("http://localhost:#{mock_server_port}/",
                                headers: { 'Content-Type': 'application/json' }, body: '{}')

      response2 = HTTParty.put("http://localhost:#{mock_server_port}/mallory", body: {
                                 complete: {
                                   certificateUri: 'http://...',
                                   issues: {},
                                   nevdis: {
                                     body: 'red',
                                     colour: nil,
                                     engine: nil
                                   },
                                   body: '123456'
                                 },
                                 body: [1, 3]
                               })

      expect(response1.code).to eq 500
      expect(response1.body).to include 'Request-Mismatch'
      expect(response2.code).to eq 500
      expect(response2.body).to include 'Unexpected-Request'
    end
  end
end
