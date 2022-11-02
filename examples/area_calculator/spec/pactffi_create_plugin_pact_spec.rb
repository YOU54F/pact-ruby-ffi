require 'httparty'
require 'pact_ruby_ffi'

RSpec.describe 'pactffi_new_plugin spec' do
  describe 'with grpcInteraction' do
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
          "value": ['matching(number, 12)', 'matching(number, 9)']
        }
      }
    end

    let(:pact) { PactRubyFfi.pactffi_new_pact('grpc-consumer-ruby', 'area-calculator-provider') }
    let(:message_pact) do
      PactRubyFfi.pactffi_new_sync_message_interaction(pact, 'pact desc')
    end
    let(:spec_version) do
      PactRubyFfi.pactffi_with_specification(pact, PactRubyFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V4'])
    end
    let(:mock_server_port) { PactRubyFfi.pactffi_create_mock_server_for_transport(pact, '127.0.0.1', 0, 'grpc', nil) }

    before do
      PactRubyFfi.pactffi_with_pact_metadata(pact,'pact-ruby','ffi',PactRubyFfi.pactffi_version) 
      PactRubyFfi.pactffi_logger_init
      PactRubyFfi.pactffi_logger_attach_sink('stderr', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactRubyFfi.pactffi_logger_apply
      PactRubyFfi.pactffi_log_message('pact_ruby', 'INFO', 'pact ruby grpc is alive')
      PactRubyFfi.pactffi_using_plugin(pact, 'protobuf', '0.1.15')
    end
    after do
      puts "Have we got a match? #{PactRubyFfi.pactffi_mock_server_matched(mock_server_port)}"
      res_write_pact = PactRubyFfi.pactffi_write_pact_file(mock_server_port, './pacts', false)
      puts "res_write_pact: #{res_write_pact}"
      PactRubyFfi.pactffi_cleanup_mock_server(mock_server_port)
      # Should this be using write message pact
      # res_write_message_pact = PactRubyFfi.pactffi_write_message_pact_file(message_pact, './pacts', false)
      # puts "res_write_message_pact: #{res_write_message_pact}"
    end
    it 'executes the pact test with errors' do
      PactRubyFfi.pactffi_interaction_contents(message_pact, 0, 'application/grpc', JSON.dump(contents))
    end
  end
end
