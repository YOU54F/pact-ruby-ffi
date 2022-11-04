require 'httparty'
require 'pact_ruby_ffi'
require 'fileutils'

RSpec.describe 'pactffi_new_message spec' do
  describe 'with matching requests' do
    let(:contents) do
      {
        "uuid": {
          "pact:matcher:type": 'regex',
          "regex": '^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$',
          "value": 'fb5a885f-f7e8-4a50-950f-c1a64a94d500'
        }
      }
    end

    let(:mock_server_port) { PactRubyFfi.pactffi_create_mock_server_for_pact(pact, '127.0.0.1:0', false) }
    let(:pact) { PactRubyFfi.pactffi_new_pact('http-consumer-2', 'http-provider') }
    let(:interaction) { PactRubyFfi.pactffi_new_interaction(pact, 'A PUT request to generate book cover') }
    let(:message_pact)  { PactRubyFfi.pactffi_new_pact('message-consumer-2', 'message-provider') }
    let(:message) do
      PactRubyFfi.pactffi_new_message(message_pact, 'Book (id fb5a885f-f7e8-4a50-950f-c1a64a94d500) created message')
    end

    before do
      PactRubyFfi.pactffi_logger_init
      FileUtils.mkdir_p 'logs' unless File.directory?('logs')
      # if the directory doesnt exist, it blows up!
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log-error.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      PactRubyFfi.pactffi_logger_attach_sink('stdout', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactRubyFfi.pactffi_logger_attach_sink('stderr', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      PactRubyFfi.pactffi_logger_apply
      PactRubyFfi.pactffi_init(PactRubyFfi::FfiLogLevel['LOG_LEVEL_INFO'])
      PactRubyFfi.pactffi_with_specification(pact, PactRubyFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V3'])
      PactRubyFfi.pactffi_upon_receiving(interaction, 'A PUT request to generate book cover')
      PactRubyFfi.pactffi_given(interaction, 'A book with id fb5a885f-f7e8-4a50-950f-c1a64a94d500 is required')
      PactRubyFfi.pactffi_with_request(interaction, 'PUT',
                                       '/api/books/fb5a885f-f7e8-4a50-950f-c1a64a94d500/generate-cover')
      PactRubyFfi.pactffi_with_header(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_REQUEST'],
                                      'Content-Type', 0, 'application/json')
      PactRubyFfi.pactffi_with_body(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_REQUEST'],
                                    'application/json', '[]')
      PactRubyFfi.pactffi_response_status(interaction, 204)
      length = JSON.dump(contents).length
      size = length + 1
      memBuf = FFI::MemoryPointer.new(:uint, length)
      memBuf.put_bytes(0, JSON.dump(contents))
      PactRubyFfi.pactffi_message_expects_to_receive(message,
                                                     'Book (id fb5a885f-f7e8-4a50-950f-c1a64a94d500) created message')
      PactRubyFfi.pactffi_message_given(message, 'A book with id fb5a885f-f7e8-4a50-950f-c1a64a94d500 is required')
      PactRubyFfi.pactffi_message_with_contents(message, 'application/json', memBuf, size)
    end
    after do
      expect(PactRubyFfi.pactffi_mock_server_matched(mock_server_port)).to be true
      res_write_pact = PactRubyFfi.pactffi_write_pact_file(mock_server_port, './pacts', false)
      res_write_message_pact = PactRubyFfi.pactffi_write_message_pact_file(message_pact, './pacts', false)
      PactRubyFfi.pactffi_cleanup_mock_server(mock_server_port)
      expect(res_write_pact).to be(0)
    end

    it 'executes the pact test with no errors' do
      puts "Mock server port=#{mock_server_port}"
      reified = PactRubyFfi.pactffi_message_reify(message)
      puts reified
      options = {

        # body: {
        #   width: '720',
        #   height: "1080",
        # },
        body: [],
        params: {
          hostname: '127.0.0.1',
          port: mock_server_port,
          path: "/api/books/#{JSON.parse(reified)['contents']['uuid']}/generate-cover",
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          }
        }
      }
      response = HTTParty.put("http://#{options[:params][:hostname]}:#{mock_server_port}#{options[:params][:path]}", {
                                body: options[:body].to_json,
                                headers: { 'Content-Type' => 'application/json' }
                              })
      expect(response.body).to eq nil
      expect(response.code).to eq 204
    end
  end
  describe 'with mismatching requests' do
    let(:contents) do
      {
        "uuid": {
          "pact:matcher:type": 'regex',
          "regex": '^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$',
          "value": 'fb5a885f-f7e8-4a50-950f-c1a64a94d500'
        }
      }
    end

    let(:mock_server_port) { PactRubyFfi.pactffi_create_mock_server_for_pact(pact, '127.0.0.1:0', false) }
    let(:pact) { PactRubyFfi.pactffi_new_pact('http-consumer-2', 'http-provider') }
    let(:interaction) { PactRubyFfi.pactffi_new_interaction(pact, 'A PUT request to generate book cover') }
    let(:message_pact)  { PactRubyFfi.pactffi_new_pact('message-consumer-2', 'message-provider') }
    let(:message) do
      PactRubyFfi.pactffi_new_message(message_pact, 'Book (id fb5a885f-f7e8-4a50-950f-c1a64a94d500) created message')
    end

    before do
      PactRubyFfi.pactffi_logger_init
      FileUtils.mkdir_p 'logs' unless File.directory?('logs')
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log-error.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      PactRubyFfi.pactffi_logger_attach_sink('stdout', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactRubyFfi.pactffi_logger_attach_sink('stderr', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      PactRubyFfi.pactffi_logger_apply
      # PactRubyFfi.pactffi_init(PactRubyFfi::FfiLogLevel['LOG_LEVEL_INFO'])      PactRubyFfi.pactffi_with_specification(pact, PactRubyFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V3'])
      PactRubyFfi.pactffi_upon_receiving(interaction, 'A PUT request to generate book cover')
      PactRubyFfi.pactffi_given(interaction, 'A book with id fb5a885f-f7e8-4a50-950f-c1a64a94d500 is required')
      PactRubyFfi.pactffi_with_request(interaction, 'PUT',
                                       '/api/books/fb5a885f-f7e8-4a50-950f-c1a64a94d500/generate-cover')
      PactRubyFfi.pactffi_with_header(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_REQUEST'],
                                      'Content-Type', 0, 'application/json')
      PactRubyFfi.pactffi_with_body(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_REQUEST'],
                                    'application/json', '[]')
      PactRubyFfi.pactffi_response_status(interaction, 204)
      length = JSON.dump(contents).length
      size = length + 1
      memBuf = FFI::MemoryPointer.new(:uint, length)
      memBuf.put_bytes(0, JSON.dump(contents))
      PactRubyFfi.pactffi_message_expects_to_receive(message,
                                                     'Book (id fb5a885f-f7e8-4a50-950f-c1a64a94d500) created message')
      PactRubyFfi.pactffi_message_given(message, 'A book with id fb5a885f-f7e8-4a50-950f-c1a64a94d500 is required')
      PactRubyFfi.pactffi_message_with_contents(message, 'application/json', memBuf, size)
    end
    after do
      expect(PactRubyFfi.pactffi_mock_server_matched(mock_server_port)).to be false
      mismatchers = PactRubyFfi.pactffi_mock_server_mismatches(mock_server_port)
      puts JSON.parse(mismatchers)
      expect(JSON.parse(mismatchers).length).to eql(1)
      PactRubyFfi.pactffi_cleanup_mock_server(mock_server_port)
    end

    it 'executes the pact test with errors' do
      puts "Mock server port=#{mock_server_port}"
      reified = PactRubyFfi.pactffi_message_reify(message)
      puts reified
      options = {

        body: {
          width: '720',
          height: '1080'
        },
        params: {
          hostname: '127.0.0.1',
          port: mock_server_port,
          path: "/api/books/#{JSON.parse(reified)['contents']['uuid']}/generate-cover",
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          }
        }
      }
      response = HTTParty.put("http://#{options[:params][:hostname]}:#{mock_server_port}#{options[:params][:path]}", {
                                body: options[:body].to_json,
                                headers: { 'Content-Type' => 'application/json' }
                              })
      expect(response.code).to eq 500
      expect(response.body).to include 'Request-Mismatch'
    end
  end
end
