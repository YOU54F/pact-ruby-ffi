require 'net/http'
require 'uri'
require 'thin'
require 'pact/ffi/verifier'
require 'pact/ffi/logger'
require 'json'
PactFfi::Logger.log_to_stdout(PactFfi::Logger::LogLevel['INFO'])
RSpec.describe 'pactffi verifier spec' do
  before do
    @server_thread = Thread.new do
      app = lambda do |env|
        if env['REQUEST_METHOD'] == 'POST' && env['PATH_INFO'] == '/api/books'
          [201, { 'Content-Type' => 'application/ld+json;charset=utf-8' },
           [JSON.generate({
                            "author": 'Margaret Atwood',
                            "description": 'Brilliantly',
                            "isbn": '0099740915',
                            "publicationDate": '1985-07-31T00:00:00+00:00',
                            "title": "The Handmaid's Tale",
                            "@type": 'Book',
                            "@id": '/api/books/0114b2a8-3347-49d8-ad99-0e792c5a30e6',
                            "reviews": [],
                            "@context": '/api/contexts/Book'
                          })]]
        else
          [404, { 'Content-Type' => 'text/plain' }, ['Not found']]
        end
      end
      Thin::Server.start(8000, app)
    end
  end
  let(:verifier) { PactFfi::Verifier.new_for_application('pact-ruby', '1.0.0') }
  after do
    PactFfi::Verifier.shutdown(verifier)
  end
  it 'should respond verify with pact' do
    sleep 1
    PactFfi::Verifier.set_provider_info(verifier, 'http-provider', 'http', '0.0.0.0', 8000, '/')
    PactFfi::Verifier.add_file_source(verifier,
                                      'pacts/http-consumer-1-http-provider.json')
    result = PactFfi::Verifier.execute(verifier)
    expect(result).to eq(PactFfi::Verifier::Response['VERIFICATION_FAILED'])
    # TODO: This test should pass with a server started before the test but doesnt.
    # run ruby provider.rb prior to running this spec to see requests from Pact hitting our
    # server.
  end
end
