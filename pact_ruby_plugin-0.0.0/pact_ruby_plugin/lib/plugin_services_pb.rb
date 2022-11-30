# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: plugin.proto for package 'io.pact.plugin'
# Original file comments:
# Proto file for Pact plugin interface V1
#

require 'grpc'
require 'plugin_pb'

module Io
  module Pact
    module Plugin
      module PactPlugin
        class Service

          include ::GRPC::GenericService

          self.marshal_class_method = :encode
          self.unmarshal_class_method = :decode
          self.service_name = 'io.pact.plugin.PactPlugin'

          # Check that the plugin loaded OK. Returns the catalogue entries describing what the plugin provides
          rpc :InitPlugin, ::Io::Pact::Plugin::InitPluginRequest, ::Io::Pact::Plugin::InitPluginResponse
          # Updated catalogue. This will be sent when the core catalogue has been updated (probably by a plugin loading).
          rpc :UpdateCatalogue, ::Io::Pact::Plugin::Catalogue, ::Google::Protobuf::Empty
          # Request to perform a comparison of some contents (matching request)
          rpc :CompareContents, ::Io::Pact::Plugin::CompareContentsRequest, ::Io::Pact::Plugin::CompareContentsResponse
          # Request to configure/setup the interaction for later verification. Data returned will be persisted in the pact file.
          rpc :ConfigureInteraction, ::Io::Pact::Plugin::ConfigureInteractionRequest, ::Io::Pact::Plugin::ConfigureInteractionResponse
          # Request to generate the content using any defined generators
          rpc :GenerateContent, ::Io::Pact::Plugin::GenerateContentRequest, ::Io::Pact::Plugin::GenerateContentResponse
          # Start a mock server
          rpc :StartMockServer, ::Io::Pact::Plugin::StartMockServerRequest, ::Io::Pact::Plugin::StartMockServerResponse
          # Shutdown a running mock server
          # TODO: Replace the message types with MockServerRequest and MockServerResults in the next major version
          rpc :ShutdownMockServer, ::Io::Pact::Plugin::ShutdownMockServerRequest, ::Io::Pact::Plugin::ShutdownMockServerResponse
          # Get the matching results from a running mock server
          rpc :GetMockServerResults, ::Io::Pact::Plugin::MockServerRequest, ::Io::Pact::Plugin::MockServerResults
          # Prepare an interaction for verification. This should return any data required to construct any request
          # so that it can be amended before the verification is run
          rpc :PrepareInteractionForVerification, ::Io::Pact::Plugin::VerificationPreparationRequest, ::Io::Pact::Plugin::VerificationPreparationResponse
          # Execute the verification for the interaction.
          rpc :VerifyInteraction, ::Io::Pact::Plugin::VerifyInteractionRequest, ::Io::Pact::Plugin::VerifyInteractionResponse
        end

        Stub = Service.rpc_stub_class
      end
    end
  end
end
