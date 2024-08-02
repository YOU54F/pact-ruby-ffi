
require 'webrick'
require 'json'
def start_server
  server = WEBrick::HTTPServer.new(Port: 8080)

  server.mount_proc('/__messages') do |_req, res|
    puts _req
    res['content-type'] = 'application/json'
    res.body = '{"one":"cat","two":"b"}'
  end

  server.start
end

start_server
