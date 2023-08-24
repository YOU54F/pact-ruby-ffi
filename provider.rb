require 'webrick'
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

server = WEBrick::HTTPServer.new(Port: port)

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

trap('INT') { server.shutdown }

server.start

puts "Server listening on port #{port}"