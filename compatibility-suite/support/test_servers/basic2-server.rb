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

port = options[:port] || 8080
server = WEBrick::HTTPServer.new(Port: port)

server.mount_proc('/__messages') do |_req, res|
  puts _req
  res['content-type'] = 'application/json'
  res.body = '{"one":"cat","two":"b"}'
end

trap('INT') { server.shutdown }

server.start
