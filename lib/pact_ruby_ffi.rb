# require 'pact_ruby_ffi/version'
require 'ffi'
require_relative 'detect_os'
import OS
# require 'json'
# require 'httparty'
module PactRubyFfi
  extend FFI::Library
  ffi_lib OS.macos? './pact/ffi/libpact_ffi.so': './pact/ffi/osxaarch64/libpact_ffi.dylib'

  FfiSpecificationVersion = Hash[
    'SPECIFICATION_VERSION_UNKNOWN' => 0,
    'SPECIFICATION_VERSION_V1' => 1,
    'SPECIFICATION_VERSION_V1_1' => 2,
    'SPECIFICATION_VERSION_V2' => 3,
    'SPECIFICATION_VERSION_V3' => 4,
    'SPECIFICATION_VERSION_V4' => 5,
  ]
  FfiWritePactResponse = Hash[
    'SUCCESS' => 0,
    'GENERAL_PANIC' => 1,
    'UNABLE_TO_WRITE_PACT_FILE' => 2,
    'MOCK_SERVER_NOT_FOUND' => 3,
  ]
  FfiWriteMessagePactResponse = Hash[
    'SUCCESS' => 0,
    'UNABLE_TO_WRITE_PACT_FILE' => 1,
    'MESSAGE_HANDLE_INVALID' => 2,
    'MOCK_SERVER_NOT_FOUND' => 3,
  ]
  FfiConfigurePluginResponse = Hash[
    'SUCCESS' => 0,
    'GENERAL_PANIC' => 1,
    'FAILED_TO_LOAD_PLUGIN' => 2,
    'PACT_HANDLE_INVALID' => 3,
  ]
  FfiPluginInteractionResponse = Hash[
    'SUCCESS' => 0,
    'A_GENERAL_PANIC_WAS_CAUGHT' => 1,
    'MOCK_SERVER_HAS_ALREADY_BEEN_STARTED' => 2,
    'INTERACTION_HANDLE_IS_INVALID' => 3,
    'CONTENT_TYPE_IS_NOT_VALID' => 4,
    'CONTENTS_JSON_IS_NOT_VALID_JSON' => 5,
    'PLUGIN_RETURNED_AN_ERROR' => 6,
  ]
  FfiInteractionPart = Hash[
    'INTERACTION_PART_REQUEST' => 0,
    'INTERACTION_PART_RESPONSE' => 1,
  ]
  # /*
  # -1	A null pointer was received
  # -2	The pact JSON could not be parsed
  # -3	The mock server could not be started
  # -4	The method panicked
  # -5	The address is not valid
  # -6	Could not create the TLS configuration with the self-signed certificate
  # */
  FfiPluginCreateMockServerErrors = Hash[
    'NULL_POINTER' => -1,
    'JSON_PARSE_ERROR' => -2,
    'MOCK_SERVER_START_FAIL' => -3,
    'CORE_PANIC' => -4,
    'ADDRESS_NOT_VALID' => -5,
    'TLS_CONFIG' => -6,
  ]
  # /*
  #  * | Error | Description |
  #  * |-------|-------------|
  #  * | 1 | The verification process failed, see output for errors |
  #  * | 2 | A null pointer was received |
  #  * | 3 | The method panicked |
  #  * | 4 | Invalid arguments were provided to the verification process |
  #  */
  FfiVerifyProviderResponse = Hash[
    'VERIFICATION_SUCCESSFUL' => 0,
    'VERIFICATION_FAILED' => 1,
    'NULL_POINTER_RECEIVED' => 2,
    'METHOD_PANICKED' => 3,
    'INVALID_ARGUMENTS' => 4,
  ]

  FfiPluginFunctionResult = Hash[
    'RESULT_OK' => 0,
    'RESULT_FAILED' => 1,
  ]

  FfiLogLevelFilter = Hash[
    'LOG_LEVEL_OFF' => 0,
    'LOG_LEVEL_ERROR' => 1,
    'LOG_LEVEL_WARN' => 2,
    'LOG_LEVEL_INFO' => 3,
    'LOG_LEVEL_DEBUG' => 4,
    'LOG_LEVEL_TRACE' => 5
  ]
  FfiLogLevel = Hash[
    'LOG_LEVEL_OFF' => 'OFF',
    'LOG_LEVEL_ERROR' => 'ERROR',
    'LOG_LEVEL_WARN' => 'WARN',
    'LOG_LEVEL_INFO' => 'INFO',
    'LOG_LEVEL_DEBUG' => 'DEBUG',
    'LOG_LEVEL_TRACE' => 'TRACE'
  ]

  # Consumer
  attach_function :pactffi_init, [:string], :pointer
  attach_function :pactffi_init_with_log_level, [:string], :pointer
  attach_function :pactffi_new_pact, %i[string string], :pointer
  attach_function :pactffi_with_specification, %i[pointer int], :bool
  attach_function :pactffi_with_pact_metadata, %i[pointer string string string], :bool
  attach_function :pactffi_new_interaction, %i[pointer string], :pointer
  attach_function :pactffi_upon_receiving, %i[pointer string], :bool
  attach_function :pactffi_given, %i[pointer string], :bool
  attach_function :pactffi_with_request, %i[pointer string string], :bool
  attach_function :pactffi_with_header, %i[pointer int string int string], :bool
  attach_function :pactffi_with_body, %i[pointer int string string], :bool
  attach_function :pactffi_response_status, %i[pointer int], :bool
  attach_function :pactffi_create_mock_server, %i[string string], :int
  attach_function :pactffi_create_mock_server_for_pact, %i[pointer string bool], :int
  attach_function :pactffi_mock_server_matched, [:int], :bool
  attach_function :pactffi_mock_server_mismatches, [:int], :string
  attach_function :pactffi_cleanup_mock_server, [:int], :bool
  attach_function :pactffi_version, [], :string
  attach_function :pactffi_write_pact_file, %i[int string bool], :int
  attach_function :pactffi_write_message_pact_file, %i[pointer string bool], :int
  # Message Pact Consumer
  attach_function :pactffi_new_message_pact, %i[string string], :pointer
  attach_function :pactffi_new_message, %i[pointer string], :pointer
  attach_function :pactffi_message_expects_to_receive, %i[pointer string], :pointer
  attach_function :pactffi_message_given, %i[pointer string], :pointer
  # update me
  attach_function :pactffi_message_with_contents, %i[pointer string pointer uint], :bool
  attach_function :pactffi_message_reify, %i[pointer], :string
  # attach_function :pactffi_message_get_contents, %i[pointer], :string

  # Verifier
  attach_function :pactffi_verifier_new_for_application, %i[string string], :pointer
  attach_function :pactffi_verifier_set_provider_info, %i[pointer string string string int string], :void
  attach_function :pactffi_verifier_set_filter_info, %i[pointer string string bool], :void
  attach_function :pactffi_verifier_set_provider_state, %i[pointer string bool bool], :void
  attach_function :pactffi_verifier_set_verification_options, %i[pointer bool int], :void
  # likely wrong array
  attach_function :pactffi_verifier_set_publish_options, %i[pointer string string string int string], :void
  attach_function :pactffi_verifier_set_consumer_filters, %i[pointer pointer int], :void
  attach_function :pactffi_verifier_add_custom_header, %i[pointer string string], :void
  attach_function :pactffi_verifier_add_file_source, %i[pointer string], :void
  attach_function :pactffi_verifier_add_directory_source, %i[pointer string], :void
  attach_function :pactffi_verifier_url_source,
                  %i[pointer string string string string bool string pointer string pointer pointer], :void
  # this is very likely wrong
  callback :pactffi_verifier_execute_callback, %i[string int], :void
  attach_function :pactffi_verifier_execute, %i[pointer], :int
  attach_function :pactffi_verifier_shutdown, %i[pointer], :int
  attach_function :pactffi_verifier_logs, %i[pointer], :string

  ### log https://docs.rs/pact_ffi/latest/pact_ffi/log/index.html
  # Fetch the in-memory logger buffer contents. This will only have any contents if the buffer sink has been configured to log to. The contents will be allocated on the heap and will need to be freed with pactffi_string_delete.
  attach_function :pactffi_fetch_log_buffer, %i[string], :string
  # # 	Convenience function to direct all logging to a task local memory buffer.
  # attach_function :pactffi_log_to_buffer, %i[],:
  # # 	Convenience function to direct all logging to a file.
  attach_function :pactffi_log_to_file, %i[string int], :int
  # # 	Convenience function to direct all logging to stderr.
  # attach_function :pactffi_log_to_stderr, %i[],:
  attach_function :pactffi_log_to_stderr, %i[int], :int
  # # 	Convenience function to direct all logging to stdout.
  attach_function :pactffi_log_to_stdout, %i[int], :int
  # # 	Apply the previously configured sinks and levels to the program. If no sinks have been setup, will set the log level to info and the target to standard out.
  attach_function :pactffi_logger_apply, [], :int
  # # 	Attach an additional sink to the thread-local logger.
  attach_function :pactffi_logger_attach_sink, %i[string int], :string
  # # 	Initialize the FFI logger with no sinks.
  attach_function :pactffi_logger_init, [], :void
  attach_function :pactffi_log_message, %i[string string string], :int
end

# ### error https://docs.rs/pact_ffi/latest/pact_ffi/error/index.html
# # Provide the error message from LAST_ERROR to the calling C code.
# attach_function :pactffi_get_error_message, %i[],:
# ### log https://docs.rs/pact_ffi/latest/pact_ffi/log/index.html
# # Fetch the in-memory logger buffer contents. This will only have any contents if the buffer sink has been configured to log to. The contents will be allocated on the heap and will need to be freed with pactffi_string_delete.
# attach_function :pactffi_fetch_log_buffer, %i[],:
# # 	Convenience function to direct all logging to a task local memory buffer.
# attach_function :pactffi_log_to_buffer, %i[],:
# # 	Convenience function to direct all logging to a file.
# attach_function :pactffi_log_to_file, %i[],:
# # 	Convenience function to direct all logging to stderr.
# attach_function :pactffi_log_to_stderr, %i[],:
# # 	Convenience function to direct all logging to stdout.
# attach_function :pactffi_log_to_stdout, %i[],:
# # 	Apply the previously configured sinks and levels to the program. If no sinks have been setup, will set the log level to info and the target to standard out.
# attach_function :pactffi_logger_apply, %i[],:
# # 	Attach an additional sink to the thread-local logger.
# attach_function :pactffi_logger_attach_sink, %i[],:
# # 	Initialize the FFI logger with no sinks.
# attach_function :pactffi_logger_init, %i[],:

# # mock server https://docs.rs/pact_ffi/latest/pact_ffi/mock_server/index.html
# # Generates an example string based on the provided regex.
# attach_function :generate_regex_value_internal %i[],:
# # 	Checks that the example string matches the given regex.
# attach_function :pactffi_check_regex⚠ %i[],:
# # 	External interface to cleanup a mock server. This function will try terminate the mock server with the given port number and cleanup any memory allocated for it. Returns true, unless a mock server with the given port number does not exist, or the function panics.
# attach_function :pactffi_cleanup_mock_server %i[],:
# # 	External interface to create a HTTP mock server. A Pact handle is passed in, as well as the port for the mock server to run on. A value of 0 for the port will result in a port being allocated by the operating system. The port of the mock server is returned.
# attach_function :pactffi_create_mock_server_for_pact %i[],:
# # 	Create a mock server for the provided Pact handle and transport. If the transport is not provided (it is a NULL pointer or an empty string), will default to an HTTP transport. The address is the interface bind to, and will default to the loopback adapter if not specified. Specifying a value of zero for the port will result in the operating system allocating the port.
# attach_function :pactffi_create_mock_server_for_transport %i[],:

# # 	Generates a datetime value from the provided format string, using the current system date and time NOTE: The memory for the returned string needs to be freed with the pactffi_string_delete function
# attach_function :pactffi_generate_datetime_string⚠ %i[],:
# # 	Generates an example string based on the provided regex. NOTE: The memory for the returned string needs to be freed with the pactffi_string_delete function.
# attach_function :pactffi_generate_regex_value⚠ %i[],:
# # 	Fetch the CA Certificate used to generate the self-signed certificate for the TLS mock server.
# attach_function :pactffi_get_tls_ca_certificate %i[],:
# # 	Fetch the logs for the mock server. This needs the memory buffer log sink to be setup before the mock server is started. Returned string will be freed with the cleanup_mock_server function call.
# attach_function :pactffi_mock_server_logs %i[],:
# # 	External interface to check if a mock server has matched all its requests. The port number is passed in, and if all requests have been matched, true is returned. False is returned if there is no mock server on the given port, or if any request has not been successfully matched, or the method panics.
# attach_function :pactffi_mock_server_matched %i[],:
# # 	External interface to get all the mismatches from a mock server. The port number of the mock server is passed in, and a pointer to a C string with the mismatches in JSON format is returned.
# attach_function :pactffi_mock_server_mismatches %i[],:
# # 	External interface to trigger a mock server to write out its pact file. This function should be called if all the consumer tests have passed. The directory to write the file to is passed as the second parameter. If a NULL pointer is passed, the current working directory is used.
# attach_function :pactffi_write_pact_file %i[],:

# ### plugins	The plugins module provides exported functions using C bindings for using plugins with Pact tests.
# #	Decrement the access count on any plugins that are loaded for the Pact. This will shutdown any plugins that are no longer required (access count is zero).
# attach_fucntion :pactffi_cleanup_plugins, %i[],:
# #	Setup the interaction part using a plugin. The contents is a JSON string that will be passed on to the plugin to configure the interaction part. Refer to the plugin documentation on the format of the JSON contents.
# attach_fucntion :pactffi_interaction_contents, %i[],:
# #	Add a plugin to be used by the test. The plugin needs to be installed correctly for this function to work.
# attach_fucntion :pactffi_using_plugin, %i[],:

# ### verifier	https://docs.rs/pact_ffi/latest/pact_ffi/verifier/index.html
# ### The verifier module provides a number of exported functions using C bindings for controlling the pact verification process. These can be used in any language that supports C bindings.

# #	Adds a custom header to be added to the requests made to the provider.
# attach_function :pactffi_verifier_add_custom_header,%i[], :
# #	Adds a Pact directory as a source to verify. All pacts from the directory that match the provider name will be verified.
# attach_function :pactffi_verifier_add_directory_source,%i[], :
# #	Adds a Pact file as a source to verify.
# attach_function :pactffi_verifier_add_file_source,%i[], :
# #	Adds a new transport for the given provider. Passing a NULL for any field will use the default value for that field.
# attach_function :pactffi_verifier_add_provider_transport,%i[], :
# #	Adds a Pact broker as a source to verify. This will fetch all the pact files from the broker that match the provider name.
# attach_function :pactffi_verifier_broker_source,%i[], :
# #	Adds a Pact broker as a source to verify. This will fetch all the pact files from the broker that match the provider name and the consumer version selectors (See https://docs.pact.io/pact_broker/advanced_topics/consumer_version_selectors/).
# attach_function :pactffi_verifier_broker_source_with_selectors,%i[], :
# #	External interface to retrieve the options and arguments available when calling the CLI interface, returning them as a JSON string.
# attach_function :pactffi_verifier_cli_args,%i[], :
# #	Runs the verification.
# attach_function :pactffi_verifier_execute,%i[], :
# #	Extracts the verification result as a JSON document. The returned string will need to be freed with the free_string function call to avoid leaking memory.
# attach_function :pactffi_verifier_json,%i[], :
# #	Extracts the logs for the verification run. This needs the memory buffer log sink to be setup before the verification is executed. The returned string will need to be freed with the free_string function call to avoid leaking memory.
# attach_function :pactffi_verifier_logs,%i[], :
# #	Extracts the logs for the verification run for the provider name. This needs the memory buffer log sink to be setup before the verification is executed. The returned string will need to be freed with the free_string function call to avoid leaking memory.
# attach_function :pactffi_verifier_logs_for_provider,%i[], :
# #	Get a Handle to a newly created verifier. You should call pactffi_verifier_shutdown when done with the verifier to free all allocated resources
# attach_function :pactffi_verifier_new_for_application,%i[], :
# #	Extracts the standard output for the verification run. The returned string will need to be freed with the free_string function call to avoid leaking memory.
# attach_function :pactffi_verifier_output,%i[], :
# #	Enables or disables coloured output using ANSI escape codes in the verifier output. By default, coloured output is enabled.
# attach_function :pactffi_verifier_set_coloured_output,%i[], :
# #	Set the consumer filters for the Pact verifier.
# attach_function :pactffi_verifier_set_consumer_filters,%i[], :
# #	Set the filters for the Pact verifier.
# attach_function :pactffi_verifier_set_filter_info,%i[], :
# #	Enables or disables if no pacts are found to verify results in an error.
# attach_function :pactffi_verifier_set_no_pacts_is_error,%i[], :
# #	Set the provider details for the Pact verifier. Passing a NULL for any field will use the default value for that field.
# attach_function :pactffi_verifier_set_provider_info,%i[], :
# #	Set the provider state for the Pact verifier.
# attach_function :pactffi_verifier_set_provider_state,%i[], :
# #	Set the options used when publishing verification results to the Pact Broker
# attach_function :pactffi_verifier_set_publish_options,%i[], :
# #	Set the options used by the verifier when calling the provider
# attach_function :pactffi_verifier_set_verification_options,%i[], :
# #	Shutdown the verifier and release all resources
# attach_function :pactffi_verifier_shutdown,%i[], :
# #	Adds a URL as a source to verify. The Pact file will be fetched from the URL.
# attach_function :pactffi_verifier_url_source,%i[], :

# ### https://docs.rs/pact_ffi/latest/pact_ffi/models/index.html
# ### consumer	FFI wrapper code for pact_matching::models::Consumer
# # Get a copy of this consumer’s name.
# pactffi_consumer_get_name
# ### http_interaction	Structs and functions to deal with HTTP Pact interactions
# pactffi_sync_http_delete	Destroy the SynchronousHttp interaction being pointed to.
# pactffi_sync_http_get_description	Get a copy of the description.
# pactffi_sync_http_get_provider_state	Get a copy of the provider state at the given index from this interaction.
# pactffi_sync_http_get_provider_state_iter	Get an iterator over provider states.
# pactffi_sync_http_get_request_contents	Get the request contents of a SynchronousHttp interaction in string form.
# pactffi_sync_http_get_request_contents_bin	Get the request contents of a SynchronousHttp interaction as a pointer to an array of bytes.
# pactffi_sync_http_get_request_contents_length	Get the length of the request contents of a SynchronousHttp interaction.
# pactffi_sync_http_get_response_contents	Get the response contents of a SynchronousHttp interaction in string form.
# pactffi_sync_http_get_response_contents_bin	Get the response contents of a SynchronousHttp interaction as a pointer to an array of bytes.
# pactffi_sync_http_get_response_contents_length	Get the length of the response contents of a SynchronousHttp interaction.
# pactffi_sync_http_new	Get a mutable pointer to a newly-created default interaction on the heap.
# pactffi_sync_http_set_description	Write the description field on the SynchronousHttp.
# pactffi_sync_http_set_request_contents	Sets the request contents of the interaction.
# pactffi_sync_http_set_request_contents_bin	Sets the request contents of the interaction as an array of bytes.
# pactffi_sync_http_set_response_contents	Sets the response contents of the interaction.
# pactffi_sync_http_set_response_contents_bin	Sets the response contents of the SynchronousHttp interaction as an array of bytes.
# ### iterators	FFI wrapper code for iterating over Pact interactions
# pactffi_pact_message_iter_delete	Free the iterator when you’re done using it.
# pactffi_pact_message_iter_next	Get the next message from the message pact. As the messages returned are owned by the iterator, they do not need to be deleted but will be cleaned up when the iterator is deleted.
# pactffi_pact_sync_http_iter_delete	Free the iterator when you’re done using it.
# pactffi_pact_sync_http_iter_next	Get the next synchronous HTTP request/response interaction from the pact. As the interactions returned are owned by the iterator, they do not need to be deleted but will be cleaned up when the iterator is deleted.
# pactffi_pact_sync_message_iter_delete	Free the iterator when you’re done using it.
# pactffi_pact_sync_message_iter_next	Get the next synchronous request/response message from the pact. As the messages returned are owned by the iterator, they do not need to be deleted but will be cleaned up when the iterator is deleted.
# ### message	The Pact Message type, including associated matching rules and provider states.
# pactffi_message_delete	Destroy the Message being pointed to.
# pactffi_message_find_metadata	Get a copy of the metadata value indexed by key.
# pactffi_message_get_contents	Get the contents of a Message in string form.
# pactffi_message_get_contents_bin	Get the contents of a Message as a pointer to an array of bytes.
# pactffi_message_get_contents_length	Get the length of the contents of a Message.
# pactffi_message_get_description	Get a copy of the description.
# pactffi_message_get_metadata_iter	Get an iterator over the metadata of a message.
# pactffi_message_get_provider_state	Get a copy of the provider state at the given index from this message.
# pactffi_message_get_provider_state_iter	Get an iterator over provider states.
# pactffi_message_insert_metadata	Insert the (key, value) pair into this Message’s metadata HashMap.
# pactffi_message_metadata_iter_delete	Free the metadata iterator when you’re done using it.
# pactffi_message_metadata_iter_next	Get the next key and value out of the iterator, if possible
# pactffi_message_metadata_pair_delete	Free a pair of key and value returned from message_metadata_iter_next.
# pactffi_message_new	Get a mutable pointer to a newly-created default message on the heap.
# pactffi_message_new_from_body	Constructs a Message from a body with a given content-type.
# pactffi_message_new_from_json	Constructs a Message from the JSON string
# pactffi_message_set_contents	Sets the contents of the message.
# pactffi_message_set_contents_bin	Sets the contents of the message as an array of bytes.
# pactffi_message_set_description	Write the description field on the Message.
# pactffi_provider_state_iter_delete	Delete the iterator.
# pactffi_provider_state_iter_next	Get the next value from the iterator.
# ### message_pact	FFI wrapper for MessagePact from pact_matching.
# pactffi_message_pact_delete	Delete the MessagePact being pointed to.
# pactffi_message_pact_find_metadata	Get a copy of the metadata value indexed by key1 and key2.
# pactffi_message_pact_get_consumer	Get a pointer to the Consumer struct inside the MessagePact. This is a mutable borrow: The caller may mutate the Consumer through this pointer.
# pactffi_message_pact_get_message_iter	Get an iterator over the messages of a message pact.
# pactffi_message_pact_get_metadata_iter	Get an iterator over the metadata of a message pact.
# pactffi_message_pact_get_provider	Get a pointer to the Provider struct inside the MessagePact. This is a mutable borrow: The caller may mutate the Provider through this pointer.
# pactffi_message_pact_message_iter_delete	Delete the iterator.
# pactffi_message_pact_message_iter_next	Get the next message from the message pact.
# pactffi_message_pact_metadata_iter_delete	Free the metadata iterator when you’re done using it.
# pactffi_message_pact_metadata_iter_next	Get the next triple out of the iterator, if possible
# pactffi_message_pact_metadata_triple_delete	Free a triple returned from pactffi_message_pact_metadata_iter_next.
# pactffi_message_pact_new_from_json	Construct a new MessagePact from the JSON string. The provided file name is used when generating error messages.
# ### pact_specification	C FFI friendly version of pact_matching::models::PactSpecification
# PactSpecification	Enum defining the pact specification versions supported by the library
# ### provider	FFI wrapper code for pact_matching::models::Provider
# pactffi_provider_get_name	Get a copy of this provider’s name.
# ### provider_state	Represents the state of providers in a message.
# pactffi_provider_state_delete	Free the provider state when you’re done using it.
# pactffi_provider_state_get_name	Get the name of the provider state as a string, which needs to be deleted with pactffi_string_delete.
# pactffi_provider_state_get_param_iter	Get an iterator over the params of a provider state.
# pactffi_provider_state_param_iter_delete	Free the provider state param iterator when you’re done using it.
# pactffi_provider_state_param_iter_next	Get the next key and value out of the iterator, if possible
# pactffi_provider_state_param_pair_delete	Free a pair of key and value returned from pactffi_provider_state_param_iter_next.
# ### sync_message	V4 Synchronous request/response messages
# pactffi_sync_message_delete	Destroy the Message being pointed to.
# pactffi_sync_message_get_description	Get a copy of the description.
# pactffi_sync_message_get_number_responses	Get the number of response messages in the SynchronousMessage.
# pactffi_sync_message_get_provider_state	Get a copy of the provider state at the given index from this message.
# pactffi_sync_message_get_provider_state_iter	Get an iterator over provider states.
# pactffi_sync_message_get_request_contents	Get the request contents of a SynchronousMessage in string form.
# pactffi_sync_message_get_request_contents_bin	Get the request contents of a SynchronousMessage as a pointer to an array of bytes.
# pactffi_sync_message_get_request_contents_length	Get the length of the request contents of a SynchronousMessage.
# pactffi_sync_message_get_response_contents	Get the response contents of a SynchronousMessage in string form.
# pactffi_sync_message_get_response_contents_bin	Get the response contents of a SynchronousMessage as a pointer to an array of bytes.
# pactffi_sync_message_get_response_contents_length	Get the length of the response contents of a SynchronousMessage.
# pactffi_sync_message_new	Get a mutable pointer to a newly-created default message on the heap.
# pactffi_sync_message_set_description	Write the description field on the SynchronousMessage.
# pactffi_sync_message_set_request_contents	Sets the request contents of the message.
# pactffi_sync_message_set_request_contents_bin	Sets the request contents of the message as an array of bytes.
# pactffi_sync_message_set_response_contents	Sets the response contents of the message. If index is greater than the number of responses in the message, the responses will be padded with default values.
# pactffi_sync_message_set_response_contents_bin	Sets the response contents of the message at the given index as an array of bytes. If index is greater than the number of responses in the message, the responses will be padded with default values.
