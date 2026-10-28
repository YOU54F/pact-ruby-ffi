require 'json'
require 'open3'
require 'rbconfig'
require 'socket'
require 'pact/ffi'
require 'pact/ffi/logger'
require 'pact/ffi/mock_server'
require 'pact/ffi/http_consumer'

# Repeated request headers (RFC 9110 §5.3, pact-reference#568 / #584).
#
# Each expected value is declared with pactffi_with_header_v2, one call per index. The
# request is written over a raw TCP socket so every field line reaches the mock server as
# its own line (HTTP clients merge, reorder or reject repeated header lines).
#
# These cases pass only with a pact_ffi that includes pact-reference#584.
module RepeatedHeaders
  REQUEST = PactFfi::FfiInteractionPart['INTERACTION_PART_REQUEST']

  def self.regex(regex, value)
    { 'pact:matcher:type' => 'regex', 'regex' => regex, 'value' => value }.to_json
  end

  def self.setup_pact(name, header, expected_values)
    pact = PactFfi.new_pact("repeated-headers-#{name}", 'repeated-headers-provider')
    PactFfi::HttpConsumer.with_specification(pact, PactFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V3'])
    interaction = PactFfi::HttpConsumer.new_interaction(pact, "a request with a repeated #{header} header (#{name})")
    PactFfi::HttpConsumer.upon_receiving(interaction, "a request with a repeated #{header} header (#{name})")
    PactFfi::HttpConsumer.with_request(interaction, 'GET', '/headers')
    expected_values.each_with_index do |value, index|
      PactFfi::HttpConsumer.with_header_v2(interaction, REQUEST, header, index, value)
    end
    PactFfi::HttpConsumer.response_status(interaction, 200)
    pact
  end

  # Writes the request by hand, one header field line per entry in field_lines.
  # Returns the HTTP status code.
  def self.send_raw(port, header, field_lines)
    socket = TCPSocket.new('127.0.0.1', port)
    request = +"GET /headers HTTP/1.1\r\nHost: 127.0.0.1:#{port}\r\n"
    field_lines.each { |line| request << "#{header}: #{line}\r\n" }
    request << "Connection: close\r\n\r\n"
    socket.write(request)
    status_line = socket.gets
    socket.read
    socket.close
    status_line.split(' ')[1].to_i
  end
end

RSpec.describe 'repeated request headers (RFC 9110 §5.3)' do
  link_values = ['<https://a.example/x,y>; rel="a"', '<https://b.example/>; rel="b"']

  cases = [
    { id: 'H1', header: 'X-Request', expected: %w[a b], sent: %w[a b], match: true },
    { id: 'H2', header: 'X-Request', expected: %w[a b], sent: ['a, b'], match: true },
    { id: 'H3', header: 'X-Sunset',
      expected: ['Sat, 01 Jan 2028 00:00:00 GMT', 'Sun, 02 Jan 2028 00:00:00 GMT'],
      sent: ['Sat, 01 Jan 2028 00:00:00 GMT', 'Sun, 02 Jan 2028 00:00:00 GMT'], match: true },
    { id: 'H4', header: 'Content-Type', expected: ['text/plain', 'text/html'],
      sent: ['text/plain, text/html'], match: false },
    { id: 'H5', header: 'Cache-Control', expected: %w[no-cache no-store],
      sent: ['no-cache, no-store'], match: true },
    { id: 'H6a', header: 'X-Request',
      expected: [RepeatedHeaders.regex('^first-\d+$', 'first-1'), RepeatedHeaders.regex('^first-\d+$', 'first-2')],
      sent: %w[first-42 first-99], match: true },
    { id: 'H6b', header: 'X-Request', expected: ['"x , y"', 'z'], sent: ['"x, y"', 'z'], match: true },
    { id: 'H8a', header: 'Link', expected: link_values, sent: link_values, match: true },
    { id: 'H8b', header: 'Link', expected: link_values, sent: [link_values.join(', ')], match: true }
  ]

  cases.each do |c|
    describe "#{c[:id]}: #{c[:header]} sent as #{c[:sent].inspect}" do
      let(:pact) { RepeatedHeaders.setup_pact(c[:id], c[:header], c[:expected]) }
      let(:mock_server_port) { PactFfi::MockServer.create_for_transport(pact, '127.0.0.1', 0, 'http', nil) }

      after do
        PactFfi::MockServer.cleanup(mock_server_port)
      end

      if c[:match]
        it 'matches with no mismatches' do
          status = RepeatedHeaders.send_raw(mock_server_port, c[:header], c[:sent])
          mismatches = JSON.parse(PactFfi::MockServer.mismatches(mock_server_port))

          expect(mismatches).to eq([])
          expect(status).to eq(200)
          expect(PactFfi::MockServer.matched(mock_server_port)).to be true
        end
      else
        it 'does not match and records a mismatch' do
          status = RepeatedHeaders.send_raw(mock_server_port, c[:header], c[:sent])
          mismatches = JSON.parse(PactFfi::MockServer.mismatches(mock_server_port))

          expect(status).not_to eq(200)
          expect(mismatches.length).to be >= 1
          expect(PactFfi::MockServer.matched(mock_server_port)).to be false
        end
      end
    end
  end

  # The FFI logger is process-wide and can only be set up once; the other specs in this
  # suite already set it to ERROR. To see the WARN line, run H6b in a child process that
  # sets up the in-memory log buffer at WARN before starting the mock server, then reads
  # the mock server's logs with pactffi_mock_server_logs.
  describe 'H6b: deprecation warning' do
    it 'logs a WARN citing RFC 9110 §5.3 for per-line matching' do
      lib_dir = File.expand_path('../lib', __dir__)
      script = <<~RUBY
        require 'socket'
        require 'pact/ffi'
        require 'pact/ffi/logger'
        require 'pact/ffi/mock_server'
        require 'pact/ffi/http_consumer'
        PactFfi::Logger.log_to_buffer(PactFfi::Logger::LogLevel['WARN'])
        request = PactFfi::FfiInteractionPart['INTERACTION_PART_REQUEST']
        pact = PactFfi.new_pact('repeated-headers-H6b-log', 'repeated-headers-provider')
        PactFfi::HttpConsumer.with_specification(pact, PactFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V3'])
        i = PactFfi::HttpConsumer.new_interaction(pact, 'H6b log')
        PactFfi::HttpConsumer.upon_receiving(i, 'H6b log')
        PactFfi::HttpConsumer.with_request(i, 'GET', '/headers')
        PactFfi::HttpConsumer.with_header_v2(i, request, 'X-Request', 0, '"x , y"')
        PactFfi::HttpConsumer.with_header_v2(i, request, 'X-Request', 1, 'z')
        PactFfi::HttpConsumer.response_status(i, 200)
        port = PactFfi::MockServer.create_for_transport(pact, '127.0.0.1', 0, 'http', nil)
        s = TCPSocket.new('127.0.0.1', port)
        s.write("GET /headers HTTP/1.1\\r\\nHost: 127.0.0.1:\#{port}\\r\\n" \\
                "X-Request: \\"x, y\\"\\r\\nX-Request: z\\r\\nConnection: close\\r\\n\\r\\n")
        s.read
        s.close
        $stdout.write(PactFfi::MockServer.logs(port).to_s)
        PactFfi::MockServer.cleanup(port)
      RUBY

      logs, status = Open3.capture2(RbConfig.ruby, '-I', lib_dir, '-e', script)
      logs = logs.dup.force_encoding(Encoding::UTF_8)
      expect(status.success?).to be true

      warnings = logs.lines.select { |line| line.include?('WARN') && line.include?('RFC 9110 §5.3') }
      expect(warnings.length).to eq(1)
      expect(warnings.first).to include('only matched when its field lines were compared one at a time')
    end
  end
end
