require 'thin'
require 'json'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: server.rb [options]"

  opts.on("-p", "--port PORT", Integer, "Port number to listen on (default: 8000)") do |port|
    options[:port] = port
  end
end.parse!

port = options[:port] || 8000

app = lambda do |env|
  if env['REQUEST_METHOD'] == 'GET' && env['PATH_INFO'] == '/alligators/Mary'
    [200, { 'Content-Type' => 'application/json' }, [JSON.generate({ name: 'Mary' })]]
  else
    [404, { 'Content-Type' => 'text/plain' }, ['Not found']]
  end
end

Thin::Server.start('0.0.0.0', port, app)

puts "Server listening on port #{port}"