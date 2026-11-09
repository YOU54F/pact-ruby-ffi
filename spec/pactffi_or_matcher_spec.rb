require 'httparty'
require 'json'
require 'tmpdir'
require 'pact/ffi'
require 'pact/ffi/logger'
require 'pact/ffi/mock_server'
require 'pact/ffi/http_consumer'

PactFfi::Logger.log_to_buffer(PactFfi::Logger::LogLevel['ERROR'])

# Requires a pact_ffi with `pact:matcher:combine` support (pact-foundation/pact-reference#601)
RSpec.describe 'with_body with an OR (pact:matcher:combine) integration JSON matcher' do
  let(:request_body) do
    {
      name: {
        'pact:matcher:type': [{ 'pact:matcher:type': 'type' }, { 'pact:matcher:type': 'null' }],
        'pact:matcher:combine': 'OR',
        value: 'Fred'
      }
    }.to_json
  end

  let(:pact) { PactFfi.new_pact('or-matcher-consumer', 'or-matcher-provider') }
  let(:interaction) { PactFfi::HttpConsumer.new_interaction(pact, 'a request with a nullable name') }
  let(:mock_server_port) { PactFfi::MockServer.create_for_transport(pact, '127.0.0.1', 0, 'http', nil) }
  let(:pact_dir) { Dir.mktmpdir }

  before do
    request_part = PactFfi::FfiInteractionPart['INTERACTION_PART_REQUEST']
    PactFfi::HttpConsumer.with_specification(pact, PactFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V3'])
    PactFfi::HttpConsumer.upon_receiving(interaction, 'a request with a nullable name')
    PactFfi::HttpConsumer.with_request(interaction, 'POST', '/people')
    PactFfi::HttpConsumer.with_header(interaction, request_part, 'Content-Type', 0, 'application/json')
    PactFfi::HttpConsumer.with_body(interaction, request_part, 'application/json', request_body)
    PactFfi::HttpConsumer.response_status(interaction, 201)
  end

  after do
    PactFfi::MockServer.cleanup(mock_server_port)
    FileUtils.remove_entry(pact_dir)
  end

  def post(name)
    HTTParty.post("http://127.0.0.1:#{mock_server_port}/people",
                  body: { name: name }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  ['Wilma', nil].each do |name|
    it "matches #{name.inspect} and writes a combine OR rule" do
      expect(post(name).code).to eq(201)
      expect(PactFfi::MockServer.matched(mock_server_port)).to be true
      expect(PactFfi::MockServer.write_pact_file(mock_server_port, pact_dir, false)).to eq(0)

      written = JSON.parse(File.read(File.join(pact_dir, 'or-matcher-consumer-or-matcher-provider.json')))
      request = written['interactions'].first['request']
      expect(request['body']).to eq('name' => 'Fred')
      expect(request['matchingRules']['body']['$.name'])
        .to eq('combine' => 'OR', 'matchers' => [{ 'match' => 'type' }, { 'match' => 'null' }])
    end
  end

  it 'does not match a value matching neither alternative' do
    post(42)
    expect(PactFfi::MockServer.matched(mock_server_port)).to be false
    expect(PactFfi::MockServer.mismatches(mock_server_port)).to include('$.name')
  end
end
