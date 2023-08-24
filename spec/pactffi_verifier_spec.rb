require 'net/http'
require 'uri'
require 'webrick'
require 'pact/ffi/verifier'
require 'pact/ffi/logger'
require 'json'
PactFfi::Logger.log_to_stdout(PactFfi::Logger::LogLevel['INFO'])
RSpec.describe 'pactffi verifier spec' do
  before(:all) do
    @server_thread = Thread.new do
      server = WEBrick::HTTPServer.new(Port: 8000)
      server.mount_proc '/api/books' do |req, res|
        if req.request_method == 'POST'
          res.status = 201
          res['Content-Type'] = 'application/ld+json;charset=utf-8'
          res.body = JSON.generate({
            "author": 'Margaret Atwood',
            "description": 'Brilliantly',
            "isbn": '0099740915',
            "publicationDate": '1985-07-31T00:00:00+00:00',
            "title": "The Handmaid's Tale",
            "@type": 'Book',
            "@id": '/api/books/0114b2a8-3347-49d8-ad99-0e792c5a30e6',
            "reviews": [],
            "@context": '/api/contexts/Book'
          })
        else
          res.status = 404
          res['Content-Type'] = 'text/plain'
          res.body = 'Not found'
        end
      end
      server.start
    end
  end
  let(:verifier) { PactFfi::Verifier.new_for_application('pact-ruby', '1.0.0') }
  after do
    PactFfi::Verifier.shutdown(verifier)
    @server_thread.kill
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
