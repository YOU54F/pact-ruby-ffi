require 'net/http'
require 'uri'
require 'webrick'
require 'pact/ffi/verifier'
require 'pact/ffi/logger'
require 'json'
PactFfi::Logger.log_to_stdout(PactFfi::Logger::LogLevel['INFO'])
RSpec.describe 'pactffi verifier spec' do
  before(:all) do
    # running in process, results in requests only hitting server when verification complete
    @pid = Process.spawn('ruby provider.rb')
    sleep(1)
  end
  after(:all) do
    puts @pid
    Process.kill('SIGKILL', @pid)
    Process.wait(@pid)
  end
  let(:verifier) { PactFfi::Verifier.new_for_application('pact-ruby', '1.0.0') }
  after do
    PactFfi::Verifier.shutdown(verifier)
    # @server_thread.kill
  end
  it 'should respond verify with pact' do
    sleep 1
    PactFfi::Verifier.set_provider_info(verifier, 'http-provider', 'http', '0.0.0.0', 8000, '/')
    PactFfi::Verifier.add_file_source(verifier,
                                      'pacts/http-consumer-1-http-provider.json')
    result = PactFfi::Verifier.execute(verifier)
    expect(result).to eq(PactFfi::Verifier::Response['VERIFICATION_SUCCESSFUL'])
  end
end
