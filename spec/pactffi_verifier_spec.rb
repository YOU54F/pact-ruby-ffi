require 'net/http'
require 'uri'
require "thin"
require "pact/ffi/verifier"
require "pact/ffi/logger"
require 'json'
PactFfi::Logger.log_to_stdout(PactFfi::Logger::LogLevel["INFO"])
RSpec.describe "pactffi verifier spec" do
  before do
    @server_thread = Thread.new do
      app = lambda do |env|
        if env['REQUEST_METHOD'] == 'GET' && env['PATH_INFO'] == '/alligators/Mary'
          [200, { 'Content-Type' => 'application/json' }, [JSON.generate({ name: 'Mary' })]]
        else
          [404, { 'Content-Type' => 'text/plain' }, ['Not found']]
        end
      end
      Thin::Server.start(8000, app)
    end
  end
  let(:verifier) { PactFfi::Verifier.new_for_application("pact-ruby", "1.0.0") }
  after do
    PactFfi::Verifier.shutdown(verifier)
  end
  it "should respond verify with pact" do
    sleep 1
    uri = URI('http://0.0.0.0:8000/alligators/Mary')
    response = Net::HTTP.get(uri)
    expect(response).to eq('{"name":"Mary"}')
    PactFfi::Verifier.set_provider_info(verifier, "http-provider", "http", "0.0.0.0", 8000, '/')
    PactFfi::Verifier.add_file_source(verifier,
                                      "pacts/v2-http.json")
    result = PactFfi::Verifier.execute(verifier)
    expect(result).to eq(PactFfi::Verifier::Response["VERIFICATION_FAILED"])
  end
end