require 'httparty'
require 'pact_ruby_ffi'
require 'fileutils'

RSpec.describe 'pactffi_create_mock_server_for_pact spec' do
  describe 'with matching requests' do
    let(:request_interaction_body) do
      '
      {
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
      }
      '
    end
    let(:response_interaction_body) do
      '
      {
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
      }
      '
    end

    let(:mock_server_port) { PactRubyFfi.pactffi_create_mock_server_for_pact(pact, '127.0.0.1:0', false) }
    let(:pact) { PactRubyFfi.pactffi_new_pact('http-consumer-1', 'http-provider') }
    let(:interaction) { PactRubyFfi.pactffi_new_interaction(pact, 'A POST request to create book') }

    before do
      PactRubyFfi.pactffi_logger_init
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log-error.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      PactRubyFfi.pactffi_logger_attach_sink('stdout', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactRubyFfi.pactffi_logger_attach_sink('stderr', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      PactRubyFfi.pactffi_logger_apply
      # PactRubyFfi.pactffi_init(PactRubyFfi::FfiLogLevel['LOG_LEVEL_INFO'])      PactRubyFfi.pactffi_with_specification(pact, PactRubyFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V3'])
      PactRubyFfi.pactffi_upon_receiving(interaction, 'A POST request to create book')
      PactRubyFfi.pactffi_given(interaction, 'No book fixtures required')
      PactRubyFfi.pactffi_with_request(interaction, 'POST', '/api/books')
      PactRubyFfi.pactffi_with_header(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_REQUEST'],
                                      'Content-Type', 0, 'application/json')
      PactRubyFfi.pactffi_with_body(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_REQUEST'],
                                    'application/json', request_interaction_body)
      PactRubyFfi.pactffi_response_status(interaction, 201)
      PactRubyFfi.pactffi_with_header(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_RESPONSE'],
                                      'Content-Type', 0, 'application/ld+json; charset=utf-8')
      PactRubyFfi.pactffi_with_body(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_RESPONSE'],
                                    'application/ld+json; charset=utf-8', response_interaction_body)
    end
    after do
      expect(PactRubyFfi.pactffi_mock_server_matched(mock_server_port)).to be true
      res_write_pact = PactRubyFfi.pactffi_write_pact_file(mock_server_port, './pacts', false)
      PactRubyFfi.pactffi_cleanup_mock_server(mock_server_port)
      expect(res_write_pact).to be(0)
    end

    it 'executes the pact test with no errors' do
      puts "Mock server port=#{mock_server_port}"

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
        params: {
          hostname: '127.0.0.1',
          path: '/api/books',
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          }
        }
      }
      response = HTTParty.post("http://#{options[:params][:hostname]}:#{mock_server_port}#{options[:params][:path]}", {
                                 body: options[:body].to_json,
                                 headers: { 'Content-Type' => 'application/json' }
                               })

      expect(response.body).to eq '{"@context":"/api/contexts/Book","@id":"/api/books/0114b2a8-3347-49d8-ad99-0e792c5a30e6","@type":"Book","author":"Melisa Kassulke","description":"Quaerat odit quia nisi accusantium natus voluptatem. Explicabo corporis eligendi ut ut sapiente ut qui quidem. Optio amet velit aut delectus. Sed alias asperiores perspiciatis deserunt omnis. Mollitia unde id in.","publicationDate":"1999-02-13T00:00:00+07:00","reviews":[],"title":"Voluptas et tempora repellat corporis excepturi."}'
    end
  end
  describe 'with mismatching requests' do
    let(:request_interaction_body) do
      '
      {
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
      }
      '
    end
    let(:response_interaction_body) do
      '
      {
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
      }
      '
    end
    
    

    let(:mock_server_port) { PactRubyFfi.pactffi_create_mock_server_for_pact(pact, '127.0.0.1:0', false) }
    let(:pact) { PactRubyFfi.pactffi_new_pact('http-consumer-1', 'http-provider') }
    let(:interaction) { PactRubyFfi.pactffi_new_interaction(pact, 'A POST request to create book') }

    # FfiLogLevelFilter = Hash[
    #   'LOG_LEVEL_OFF' => 0,
    #   'LOG_LEVEL_ERROR' => 1,
    #   'LOG_LEVEL_WARN' => 2,
    #   'LOG_LEVEL_INFO' => 3,
    #   'LOG_LEVEL_DEBUG' => 4,
    #   'LOG_LEVEL_TRACE' => 5
    # ]
    before do
      # create logs directory as pactffi_logger_attach_sink fails if it doesn't exist
      FileUtils.mkdir_p 'logs' unless File.directory?('logs')
      # PactRubyFfi.pactffi_logger_init_with_level(PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_OFF'])
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log-debug.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log-error.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_ERROR'])
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log-trace.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_TRACE'])
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log-warn.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_WARN'])
      # PactRubyFfi.pactffi_logger_attach_sink('stdout', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_OFF'])  # stack trace, cant pass this value
      # PactRubyFfi.pactffi_logger_attach_sink('stdout', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_ERROR'])
      # PactRubyFfi.pactffi_logger_attach_sink('stdout', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_WARN'])
      PactRubyFfi.pactffi_logger_attach_sink('stdout', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      # PactRubyFfi.pactffi_logger_attach_sink('stdout', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      # PactRubyFfi.pactffi_logger_attach_sink('stdout', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_TRACE'])
      PactRubyFfi.pactffi_logger_attach_sink('stderr', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_ERROR'])
      PactRubyFfi.pactffi_logger_apply
      PactRubyFfi.pactffi_log_message('pact_ruby', 'INFO', 'INFO ----- saf')
      PactRubyFfi.pactffi_log_message('pact_ruby', 'DEBUG', 'DEBUG ----- saf')
      PactRubyFfi.pactffi_log_message('pact_ruby', 'TRACE', 'TRACE ----- saf')
      PactRubyFfi.pactffi_log_message('pact_ruby', 'WARN', 'WARN ----- saf')
      PactRubyFfi.pactffi_log_message('pact_ruby', 'ERROR', 'ERROR ----- saf')
      # PactRubyFfi.pactffi_init(PactRubyFfi::FfiLogLevel['LOG_LEVEL_INFO'])      PactRubyFfi.pactffi_with_specification(pact, PactRubyFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V3'])
      PactRubyFfi.pactffi_upon_receiving(interaction, 'A POST request to create book')
      PactRubyFfi.pactffi_given(interaction, 'No book fixtures required')
      PactRubyFfi.pactffi_with_request(interaction, 'POST', '/api/books')
      PactRubyFfi.pactffi_with_header(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_REQUEST'],
                                      'Content-Type', 0, 'application/json')
      PactRubyFfi.pactffi_with_body(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_REQUEST'],
                                    'application/json', request_interaction_body)
      PactRubyFfi.pactffi_response_status(interaction, 201)
      PactRubyFfi.pactffi_with_header(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_RESPONSE'],
                                      'Content-Type', 0, 'application/ld+json; charset=utf-8')
      PactRubyFfi.pactffi_with_body(interaction, PactRubyFfi::FfiInteractionPart['INTERACTION_PART_RESPONSE'],
                                    'application/ld+json; charset=utf-8', response_interaction_body)
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

      options = {

        body: {
          isbn: '0099740915',
          title: 123,
          description: 'Natus ut doloribus magni. Impedit aperiam ea similique. Sed architecto quod nulla maxime. Quibusdam inventore esse harum accusantium rerum nulla voluptatem.',
          author: 'Maryse Kulas',
          publicationDate: 'tommorow'
        },
        params: {
          hostname: '127.0.0.1',
          path: '/api/books',
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          }
        }
      }
      response = HTTParty.post("http://#{options[:params][:hostname]}:#{mock_server_port}#{options[:params][:path]}", {
                                 body: options[:body].to_json,
                                 headers: { 'Content-Type' => 'application/json' }
                               })
    end
  end
end
