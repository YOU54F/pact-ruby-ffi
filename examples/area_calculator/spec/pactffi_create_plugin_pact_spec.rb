require 'pact_ruby_ffi'
require_relative '../area_calculator_consumer'
include AreaCalculatorConsumer
require 'grpc'

RSpec.describe 'pactffi_new_plugin spec' do
  describe 'with grpcInteraction - calculateOne' do
    let(:contents) do
      {
        "pact:proto": File.expand_path("./proto/area_calculator.proto"),
        "pact:proto-service": 'Calculator/calculateOne',
        "pact:content-type": 'application/protobuf',
        "request": {
          "rectangle": {
            "length": 'matching(equalTo, 9)',
            "width": 'matching(number, 4)'
          }
        },
        "response": {
          "value": ['matching(number, 12)']
        }
      }
    end

    let(:pact) { PactRubyFfi.pactffi_new_pact('grpc-consumer-ruby', 'area-calculator-provider') }
    let(:message_pact) do
      PactRubyFfi.pactffi_new_sync_message_interaction(pact, 'pact calc 2')
    end
    let(:spec_version) do
      PactRubyFfi.pactffi_with_specification(pact, PactRubyFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V4'])
    end
    # let(:mock_server_port) { PactRubyFfi.pactffi_create_mock_server_for_transport(pact, '0.0.0.0', 0, 'grpc', nil) }
    let(:mock_server_port) { PactRubyFfi.pactffi_create_mock_server_for_transport(pact, '0.0.0.0', 0, 'grpc', nil) }
    # let(:plugin) { PactRubyFfi.pactffi_using_plugin(pact, 'protobuf', '0.1.17') }

    before do
      PactRubyFfi.pactffi_with_pact_metadata(pact, 'pact-ruby', 'ffi', PactRubyFfi.pactffi_version)
      # Test fails with v0.1.16 of protobuf plugin, if logger is enabled.
      # PactRubyFfi.pactffi_logger_init
      # PactRubyFfi.pactffi_logger_attach_sink('stdout', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      # PactRubyFfi.pactffi_logger_attach_sink('stderr', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      # PactRubyFfi.pactffi_logger_apply
      # PactRubyFfi.pactffi_log_message('pact_ruby', 'INFO', 'pact ruby grpc is alive')
      PactRubyFfi.pactffi_using_plugin(pact, 'protobuf', '0.1.17')
    end
    after do
      result = PactRubyFfi.pactffi_mock_server_matched(mock_server_port)
      if result == true
        p "pactffi_mock_server_matched: #{result}"
        res_write_pact = PactRubyFfi.pactffi_write_pact_file(mock_server_port, './pacts', false)
        if res_write_pact == 0
          p 'pact file generated'
        else
          p "Failed to write pact file: #{res_write_pact}"
        end
      else
        p "pactffi_mock_server_matched: #{result}"
        mismatchers = PactRubyFfi.pactffi_mock_server_mismatches(mock_server_port)
        if JSON.parse(mismatchers).length == 0
          raise 'the mock server returned matched false, but there are no mismatches to report, this shouldn\t be the case'
        end

        p "Failed to match all pacts: #{mismatchers}"
        puts JSON.parse(mismatchers)
      end

      PactRubyFfi.pactffi_cleanup_mock_server(mock_server_port)
      PactRubyFfi.pactffi_cleanup_plugins(pact)

      # Should this be using write message pact
      # res_write_message_pact = PactRubyFfi.pactffi_write_message_pact_file(message_pact, './pacts', false)
      # puts "res_write_message_pact: #{res_write_message_pact}"
    end
    it 'executes the pact test without errors' do
      PactRubyFfi.pactffi_interaction_contents(message_pact, 0, 'application/grpc', JSON.dump(contents))
      res = AreaCalculatorConsumer.get_rectangle_area("localhost:#{mock_server_port}")
      expect(res).to eq([12.0])
    end
  end

  # This test is skipped (method not implemented)
  xdescribe 'with grpcInteraction - calculateMulti' do
    let(:contents) do
      {
        "pact:proto": File.expand_path('./examples/area_calculator/proto/area_calculator.proto'),
        "pact:proto-service": 'Calculator/calculateMulti',
        "pact:content-type": 'application/protobuf',
        "request": {
          "shapes": [
            {
              "rectangle": {
                "length": 'matching(number, 3)',
                "width": 'matching(number, 4)'
              }
            },
            {
              "square": {
                "edge_length": 'matching(number, 3)'
              }
            }
          ]
        },
        "response": {
          "value": ['matching(string, 12)', 'matching(number, 9)']
        }
      }
    end
  end
end
