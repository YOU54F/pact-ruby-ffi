require 'pact/ffi'
require 'pact/ffi/logger'
require 'pact/ffi/mock_server'
require 'pact/ffi/http_consumer'
require 'pact/ffi/utils'
require 'json'


PactFfi::Logger::log_to_stdout(5);
@pact = PactFfi::HttpConsumer::new_pact("V4-consumer","V4-provider");
@interaction = PactFfi::HttpConsumer::new_interaction(@pact, "interaction for a consumer test")
PactFfi::HttpConsumer.with_specification(@pact, PactFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V4'])
PactFfi::Utils::set_key(@interaction, "foo");
PactFfi::Utils::set_comment(@interaction, "text", "bar");
PactFfi::Utils::set_pending(@interaction, true);
@mock_server_port = PactFfi::MockServer.create_for_transport(@pact, '127.0.0.1', 0, "http", nil)
PactFfi::MockServer::write_pact_file(@mock_server_port, './pacts', true)
pact_file_path = './pacts/V4-consumer-V4-provider.json'
pact_file_content = File.read(pact_file_path)
pact_json = JSON.parse(pact_file_content)
puts pact_json["interactions"][0]
puts pact_json["interactions"][0]["type"]