require 'pact/ffi'
require 'pact/ffi/logger'
require 'pact/ffi/mock_server'
require 'pact/ffi/http_consumer'
require 'pact/ffi/utils'
require 'pact/ffi/verifier'
require 'json'
require 'httparty'

# # incoming consumer request has query param not expected in consumer test.
# # fails correctly
# PactFfi::Logger::log_to_stdout(5);
@pact = PactFfi::HttpConsumer::new_pact("V4-consumer","V4-provider");
@interaction = PactFfi::HttpConsumer::new_interaction(@pact, "interaction for a consumer test")
PactFfi::HttpConsumer.with_specification(@pact, PactFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V2'])
PactFfi::Utils::set_key(@interaction, "foo");
PactFfi::Utils::set_comment(@interaction, "text", "bar");
PactFfi::Utils::set_pending(@interaction, true);
@mock_server_port = PactFfi::MockServer.create_for_transport(@pact, '127.0.0.1', 0, "http", nil)
response = HTTParty.get("http://127.0.0.1:#{@mock_server_port}/?name=ron&status=good")
puts response
matched = PactFfi::MockServer::matched(@mock_server_port)
puts matched
mismatches = PactFfi::MockServer::mismatches(@mock_server_port)
puts mismatches
PactFfi::MockServer::write_pact_file(@mock_server_port, './pacts', true)
pact_file_path = './pacts/V4-consumer-V4-provider.json'
pact_file_content = File.read(pact_file_path)
pact_json = JSON.parse(pact_file_content)
puts pact_json["interactions"][0]
puts pact_json["interactions"][0]["type"]

# message when array is longer than expected
# fails correctly
# PactFfi::Logger::log_to_stdout(5);
@pact = PactFfi::HttpConsumer::new_pact("V4-consumer","V4-provider");
@interaction = PactFfi::HttpConsumer::new_interaction(@pact, "interaction for a consumer test")
PactFfi::HttpConsumer.with_specification(@pact, PactFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V3'])
PactFfi::HttpConsumer.with_request(@interaction,'GET', '/thing')
PactFfi::HttpConsumer.with_body(@interaction,1,'application/json',JSON.dump({
  "factories":[{
        "location": "Sydney",
        "capacity": 5
    }],
}))
puts PactFfi::HttpConsumer.with_matching_rules(@interaction,1,JSON.dump(
{"body": 
  {"$.factories[0]": {
      "matchers": [
        {
          "match": "type"
        }
      ]
    }}
}))
@mock_server_port = PactFfi::MockServer.create_for_transport(@pact, '127.0.0.1', 0, "http", nil)
PactFfi::MockServer::write_pact_file(@mock_server_port, './pacts', true)
verifier = PactFfi::Verifier.new_for_application('pact-ruby', '1.0.0')
PactFfi::Verifier.set_provider_info(verifier, 'V4-provider', 'http', nil, 9292, '/')
PactFfi::Verifier.add_file_source(verifier,
                                  'pacts/V4-consumer-V4-provider.json')
result = PactFfi::Verifier.execute(verifier)
puts result