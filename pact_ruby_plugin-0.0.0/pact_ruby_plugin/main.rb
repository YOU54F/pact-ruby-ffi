#!/usr/bin/env ruby
this_dir = __dir__
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'bundler/setup'
require 'grpc'
require 'plugin_services_pb'
require 'json'
require 'securerandom'

require 'logger'


module Logging
  class << self
    def logger
      @logger ||= Logger.new($stdout)
    end

    attr_writer :logger
  end

  # Addition
  def self.included(base)
    class << base
      def logger
        Logging.logger
      end
    end
  end

  def logger
    Logging.logger
  end
end


# require 'socket'

class PactRubyPluginServer < Io::Pact::Plugin::PactPlugin::Service
  include Logging
  # add_enum "io.pact.plugin.CatalogueEntry.EntryType" do
  #   value :CONTENT_MATCHER, 0
  #   value :CONTENT_GENERATOR, 1
  #   value :TRANSPORT, 2
  #   value :MATCHER, 3
  #   value :INTERACTION, 4
  # end
  def init_plugin(init_plugin_req, _unused_call)
    logger.info("Received InitPluginRequest: #{JSON.pretty_generate(init_plugin_req.to_h)}")
    content_matcher_req = [{
      'key' => 'saf',
      'type' => 0,
      'values' => { 'content-types' => 'application/saf' }
    }]
    Io::Pact::Plugin::InitPluginResponse.new(catalogue: content_matcher_req)
  end

  def update_catalogue(update_catalogue_req, _unused_call)
    catalogue_req = update_catalogue_req.to_h
    catalogue = catalogue_req[:catalogue]
    logger.info("Received Updated Catalogue: #{JSON.pretty_generate(catalogue_req[:catalogue])}")
    Google::Protobuf::Empty.new
  end

  def compare_contents(compare_contents_req, _unused_call)
    compare_contents = compare_contents_req.to_h
    logger.info("Received compare_contents_req: #{JSON.pretty_generate(compare_contents)}")
    actual = compare_contents[:actual][:content][:value]
    expected = compare_contents[:expected][:content][:value]
    # actual := parseMattMessage(string(req.Actual.Content.Value))
    # expected := parseMattMessage(string(req.Expected.Content.Value))
    if actual != expected
      mismatch = "expected body: #{expected} is not equal to actual body: #{actual}"
      logger.info("Mismatch found: #{mismatch}")
      Io::Pact::Plugin::CompareContentsResponse.new({
                                                      results: { "$": {
                                                        mismatches:
                                                      [{
                                                        expected: Google::Protobuf::BytesValue.new(value: expected),
                                                        actual: Google::Protobuf::BytesValue.new(value: actual),
                                                        mismatch: mismatch,
                                                        path: '$',
                                                        diff: 'diff'
                                                      }]
                                                      } },
                                                      error: 'mismatch'
                                                    })
    else
      Io::Pact::Plugin::CompareContentsResponse.new
    end
  end

  # TODO
  # Request to configure/setup the interaction for later verification. Data returned will be persisted in the pact file.
  def configure_interaction(configure_interaction_req, _unused_call)
    print "Received configure_interaction_req: #{JSON.pretty_generate(configure_interaction_req.to_h)}"
    contents_config = configure_interaction_req.to_h
    # print "Parsed contents_config: #{contents_config[:Request][:Body]}, #{contents_config["Response"]["Body"]}"

    # Google::Protobuf::Empty.new()
    pp contents_config
    Io::Pact::Plugin::ConfigureInteractionResponse.new(interaction: [])
  end

  # Request to generate the content using any defined generators
  # construct your buff strings https://onlinestringtools.com/convert-string-to-decimal
  def generate_content(generate_content_req, _unused_call)
    generate_content = generate_content_req.to_h
    logger.info("Received GenerateContent request: #{JSON.pretty_generate(generate_content)}")
    # generators = generate_content[:generators]
    # plugin_configuration = generate_content[:pluginConfiguration]
    content = generate_content[:contents][:content]
    if content[:value]
      config = content[:value]
      response_body = "YOU#{config}SAF"
      logger.info("Returning GenerateContent response: #{JSON.pretty_generate(response_body)}")
      return Io::Pact::Plugin::GenerateContentResponse.new(contents: {
                                                             contentType: 'application/saf',
                                                             content: Google::Protobuf::BytesValue.new(value: response_body)
                                                           })
    end
    response_body = 'YOUSAF'
    logger.info("Returning DefaultGenerateContent response: #{JSON.pretty_generate(response_body)}")
    Io::Pact::Plugin::GenerateContentResponse.new(contents: {
                                                    contentType: 'application/saf',
                                                    content: Google::Protobuf::BytesValue.new(value: response_body)
                                                  })
  end

  # TODO
  def start_mock_server(_start_mock_server_req, _unused_call)
    print "Received start_mock_server_req: #{JSON.pretty_generate(start_mock_server.to_h)}"
    Google::Protobuf::Empty.new
    # Io::Pact::Plugin::StartMockServerResponse.new()
  end

  # TODO
  def shutdown_mock_server(shutdown_mock_server_req, _unused_call)
    print "Received shutdown_mock_server_req: #{JSON.pretty_generate(shutdown_mock_server_req.to_h)}"
    Google::Protobuf::Empty.new
    # Io::Pact::Plugin::ShutdownMockServerResponse.new()
  end

  # TODO
  def get_mock_server_results(get_mock_server_results_req, _unused_call)
    print "Received get_mock_server_results_req: #{JSON.pretty_generate(get_mock_server_results_req.to_h)}"
    Google::Protobuf::Empty.new
    # Io::Pact::Plugin::MockServerResults.new()
  end

  # TODO
  def prepare_interaction_for_verification(prepare_interaction_for_verification_req, _unused_call)
    print "Received prepare_interaction_for_verification: #{JSON.pretty_generate(prepare_interaction_for_verification_req.to_h)}"
    Google::Protobuf::Empty.new
    # Io::Pact::Plugin::VerificationPreparationResponse.new()
  end

  # TODO
  def verify_interaction_response(verify_interaction_response_req, _unused_call)
    print "Received get_mock_server_results_req: #{JSON.pretty_generate(verify_interaction_response_req.to_h)}"
    Google::Protobuf::Empty.new
    # Io::Pact::Plugin::VerifyInteractionResponse.new()
  end
end

def main
  include Logging
  # socket = Socket.new(:INET, :STREAM, 0)
  # port = socket.local_address.inspect_sockaddr.split(':')[1].to_i
  # hostname = socket.local_address.inspect_sockaddr

  # host = '0.0.0.0:50051'
  host = '127.0.0.1:50051'
  port = host.split(':')[1]
  server_key = SecureRandom.uuid
  s = GRPC::RpcServer.new
  s.add_http2_port(host, :this_port_is_insecure)
  # GRPC.logger.info("{\"port\": #{port}, \"serverKey\": \"#{server_key}\"}")
  # puts JSON.dump({"port": port, "serverKey": server_key})
  puts JSON.dump({"port": port.to_i, "serverKey": ''})
  s.handle(PactRubyPluginServer)
  # Runs the server with SIGHUP, SIGINT and SIGTERM signal handlers to
  #   gracefully shutdown.
  # User could also choose to run server via call to run_till_terminated
  if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG['arch']) != nil
    # s.run_till_terminated
  else
    s.run_till_terminated_or_interrupted([1, 'int', 'SIGTERM']) # this works on ubuntu/macos but fails on windows
    # s.run
  end
end

main
