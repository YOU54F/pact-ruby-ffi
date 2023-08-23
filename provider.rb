require 'thin'
require 'json'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: server.rb [options]'

  opts.on('-p', '--port PORT', Integer, 'Port number to listen on (default: 8000)') do |port|
    options[:port] = port
  end
end.parse!

port = options[:port] || 8000

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

Thin::Server.start('0.0.0.0', port, app)

puts "Server listening on port #{port}"
