# require 'pact-ffi/version'
require 'ffi'
require 'pact/detect_os'

module PactFfi
  extend FFI::Library
  ffi_lib DetectOS.get_bin_path

  # at least neccessary on x64-mingw-ucrt as uint32_type is undefined
  # also neccessary on linux aarch64 it seems
  DetectOS.windows? || DetectOS.linux_arm? ? (typedef :uint32, :uint32_type) : (typedef :uint32_t, :uint32_type)

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

  # These bork on windows not sure they they are added in
  # as part of deno-bindgen, maybe the include headers
  # attach_function :malloc, %i[size_t], :pointer
  # attach_function :calloc, %i[size_t size_t], :pointer
  # attach_function :realloc, %i[pointer size_t], :pointer
  # attach_function :free, %i[pointer], :void
  # attach_function :posix_memalign, %i[pointer size_t size_t], :int32
  # attach_function :abort, %i[], :void
  # attach_function :getenv, %i[string], :string
  # attach_function :realpath, %i[string string], :string

  attach_function :pactffi_version, %i[], :string
  attach_function :pactffi_init, %i[string], :void
  attach_function :pactffi_init_with_log_level, %i[string], :void
  attach_function :pactffi_enable_ansi_support, %i[], :void
  attach_function :pactffi_log_message, %i[string string string], :void
  attach_function :pactffi_match_message, %i[pointer pointer], :pointer
  attach_function :pactffi_mismatches_get_iter, %i[pointer], :pointer
  attach_function :pactffi_mismatches_delete, %i[pointer], :void
  attach_function :pactffi_mismatches_iter_next, %i[pointer], :pointer
  attach_function :pactffi_mismatches_iter_delete, %i[pointer], :void
  attach_function :pactffi_mismatch_to_json, %i[pointer], :string
  attach_function :pactffi_mismatch_type, %i[pointer], :string
  attach_function :pactffi_mismatch_summary, %i[pointer], :string
  attach_function :pactffi_mismatch_description, %i[pointer], :string
  attach_function :pactffi_mismatch_ansi_description, %i[pointer], :string
  attach_function :pactffi_get_error_message, %i[string int32], :int32
  attach_function :pactffi_log_to_stdout, %i[int32], :int32
  attach_function :pactffi_log_to_stderr, %i[int32], :int32
  attach_function :pactffi_log_to_file, %i[string int32], :int32
  attach_function :pactffi_log_to_buffer, %i[int32], :int32
  attach_function :pactffi_logger_init, %i[], :void
  attach_function :pactffi_logger_attach_sink, %i[string int32], :int32
  attach_function :pactffi_logger_apply, %i[], :int32
  attach_function :pactffi_fetch_log_buffer, %i[string], :string
  attach_function :pactffi_parse_pact_json, %i[string], :pointer
  attach_function :pactffi_pact_model_delete, %i[pointer], :void
  attach_function :pactffi_pact_model_interaction_iterator, %i[pointer], :pointer
  attach_function :pactffi_pact_spec_version, %i[pointer], :int32
  attach_function :pactffi_pact_interaction_delete, %i[pointer], :void
  attach_function :pactffi_async_message_new, %i[], :pointer
  attach_function :pactffi_async_message_delete, %i[pointer], :void
  attach_function :pactffi_async_message_get_contents, %i[pointer], :pointer
  attach_function :pactffi_async_message_get_contents_str, %i[pointer], :string
  attach_function :pactffi_async_message_set_contents_str, %i[pointer string string], :void
  attach_function :pactffi_async_message_get_contents_length, %i[pointer], :size_t
  attach_function :pactffi_async_message_get_contents_bin, %i[pointer], :pointer
  attach_function :pactffi_async_message_set_contents_bin, %i[pointer pointer size_t string], :void
  attach_function :pactffi_async_message_get_description, %i[pointer], :string
  attach_function :pactffi_async_message_set_description, %i[pointer string], :int32
  attach_function :pactffi_async_message_get_provider_state, %i[pointer uint32_type], :pointer
  attach_function :pactffi_async_message_get_provider_state_iter, %i[pointer], :pointer
  attach_function :pactffi_consumer_get_name, %i[pointer], :string
  attach_function :pactffi_pact_get_consumer, %i[pointer], :pointer
  attach_function :pactffi_pact_consumer_delete, %i[pointer], :void
  attach_function :pactffi_message_contents_get_contents_str, %i[pointer], :string
  attach_function :pactffi_message_contents_set_contents_str, %i[pointer string string], :void
  attach_function :pactffi_message_contents_get_contents_length, %i[pointer], :size_t
  attach_function :pactffi_message_contents_get_contents_bin, %i[pointer], :pointer
  attach_function :pactffi_message_contents_set_contents_bin, %i[pointer pointer size_t string], :void
  attach_function :pactffi_message_contents_get_metadata_iter, %i[pointer], :pointer
  attach_function :pactffi_message_contents_get_matching_rule_iter, %i[pointer int32], :pointer
  attach_function :pactffi_request_contents_get_matching_rule_iter, %i[pointer int32], :pointer
  attach_function :pactffi_response_contents_get_matching_rule_iter, %i[pointer int32], :pointer
  attach_function :pactffi_message_contents_get_generators_iter, %i[pointer int32], :pointer
  attach_function :pactffi_request_contents_get_generators_iter, %i[pointer int32], :pointer
  attach_function :pactffi_response_contents_get_generators_iter, %i[pointer int32], :pointer
  attach_function :pactffi_parse_matcher_definition, %i[string], :pointer
  attach_function :pactffi_matcher_definition_error, %i[pointer], :string
  attach_function :pactffi_matcher_definition_value, %i[pointer], :string
  attach_function :pactffi_matcher_definition_delete, %i[pointer], :void
  attach_function :pactffi_matcher_definition_generator, %i[pointer], :pointer
  attach_function :pactffi_matcher_definition_value_type, %i[pointer], :int32
  attach_function :pactffi_matching_rule_iter_delete, %i[pointer], :void
  attach_function :pactffi_matcher_definition_iter, %i[pointer], :pointer
  attach_function :pactffi_matching_rule_iter_next, %i[pointer], :pointer
  attach_function :pactffi_matching_rule_id, %i[pointer], :uint16
  attach_function :pactffi_matching_rule_value, %i[pointer], :string
  attach_function :pactffi_matching_rule_pointer, %i[pointer], :pointer
  attach_function :pactffi_matching_rule_reference_name, %i[pointer], :string
  attach_function :pactffi_validate_datetime, %i[string string], :int32
  attach_function :pactffi_generator_to_json, %i[pointer], :string
  attach_function :pactffi_generator_generate_string, %i[pointer string], :string
  attach_function :pactffi_generator_generate_integer, %i[pointer string], :uint16
  attach_function :pactffi_generators_iter_delete, %i[pointer], :void
  attach_function :pactffi_generators_iter_next, %i[pointer], :pointer
  attach_function :pactffi_generators_iter_pair_delete, %i[pointer], :void
  attach_function :pactffi_sync_http_new, %i[], :pointer
  attach_function :pactffi_sync_http_delete, %i[pointer], :void
  attach_function :pactffi_sync_http_get_request, %i[pointer], :pointer
  attach_function :pactffi_sync_http_get_request_contents, %i[pointer], :string
  attach_function :pactffi_sync_http_set_request_contents, %i[pointer string string], :void
  attach_function :pactffi_sync_http_get_request_contents_length, %i[pointer], :size_t
  attach_function :pactffi_sync_http_get_request_contents_bin, %i[pointer], :pointer
  attach_function :pactffi_sync_http_set_request_contents_bin, %i[pointer pointer size_t string], :void
  attach_function :pactffi_sync_http_get_response, %i[pointer], :pointer
  attach_function :pactffi_sync_http_get_response_contents, %i[pointer], :string
  attach_function :pactffi_sync_http_set_response_contents, %i[pointer string string], :void
  attach_function :pactffi_sync_http_get_response_contents_length, %i[pointer], :size_t
  attach_function :pactffi_sync_http_get_response_contents_bin, %i[pointer], :pointer
  attach_function :pactffi_sync_http_set_response_contents_bin, %i[pointer pointer size_t string], :void
  attach_function :pactffi_sync_http_get_description, %i[pointer], :string
  attach_function :pactffi_sync_http_set_description, %i[pointer string], :int32
  attach_function :pactffi_sync_http_get_provider_state, %i[pointer uint32_type], :pointer
  attach_function :pactffi_sync_http_get_provider_state_iter, %i[pointer], :pointer
  attach_function :pactffi_pact_interaction_as_synchronous_http, %i[pointer], :pointer
  attach_function :pactffi_pact_interaction_as_message, %i[pointer], :pointer
  attach_function :pactffi_pact_interaction_as_asynchronous_message, %i[pointer], :pointer
  attach_function :pactffi_pact_interaction_as_synchronous_message, %i[pointer], :pointer
  attach_function :pactffi_pact_message_iter_delete, %i[pointer], :void
  attach_function :pactffi_pact_message_iter_next, %i[pointer], :pointer
  attach_function :pactffi_pact_sync_message_iter_next, %i[pointer], :pointer
  attach_function :pactffi_pact_sync_message_iter_delete, %i[pointer], :void
  attach_function :pactffi_pact_sync_http_iter_next, %i[pointer], :pointer
  attach_function :pactffi_pact_sync_http_iter_delete, %i[pointer], :void
  attach_function :pactffi_pact_interaction_iter_next, %i[pointer], :pointer
  attach_function :pactffi_pact_interaction_iter_delete, %i[pointer], :void
  attach_function :pactffi_matching_rule_to_json, %i[pointer], :string
  attach_function :pactffi_matching_rules_iter_delete, %i[pointer], :void
  attach_function :pactffi_matching_rules_iter_next, %i[pointer], :pointer
  attach_function :pactffi_matching_rules_iter_pair_delete, %i[pointer], :void
  attach_function :pactffi_message_new, %i[], :pointer
  attach_function :pactffi_message_new_from_json, %i[uint32_type string int32], :pointer
  attach_function :pactffi_message_new_from_body, %i[string string], :pointer
  attach_function :pactffi_message_delete, %i[pointer], :void
  attach_function :pactffi_message_get_contents, %i[pointer], :string
  attach_function :pactffi_message_set_contents, %i[pointer string string], :void
  attach_function :pactffi_message_get_contents_length, %i[pointer], :size_t
  attach_function :pactffi_message_get_contents_bin, %i[pointer], :pointer
  attach_function :pactffi_message_set_contents_bin, %i[pointer pointer size_t string], :void
  attach_function :pactffi_message_get_description, %i[pointer], :string
  attach_function :pactffi_message_set_description, %i[pointer string], :int32
  attach_function :pactffi_message_get_provider_state, %i[pointer uint32_type], :pointer
  attach_function :pactffi_message_get_provider_state_iter, %i[pointer], :pointer
  attach_function :pactffi_provider_state_iter_next, %i[pointer], :pointer
  attach_function :pactffi_provider_state_iter_delete, %i[pointer], :void
  attach_function :pactffi_message_find_metadata, %i[pointer string], :string
  attach_function :pactffi_message_insert_metadata, %i[pointer string string], :int32
  attach_function :pactffi_message_metadata_iter_next, %i[pointer], :pointer
  attach_function :pactffi_message_get_metadata_iter, %i[pointer], :pointer
  attach_function :pactffi_message_metadata_iter_delete, %i[pointer], :void
  attach_function :pactffi_message_metadata_pair_delete, %i[pointer], :void
  attach_function :pactffi_message_pact_new_from_json, %i[string string], :pointer
  attach_function :pactffi_message_pact_delete, %i[pointer], :void
  attach_function :pactffi_message_pact_get_consumer, %i[pointer], :pointer
  attach_function :pactffi_message_pact_get_provider, %i[pointer], :pointer
  attach_function :pactffi_message_pact_get_message_iter, %i[pointer], :pointer
  attach_function :pactffi_message_pact_message_iter_next, %i[pointer], :pointer
  attach_function :pactffi_message_pact_message_iter_delete, %i[pointer], :void
  attach_function :pactffi_message_pact_find_metadata, %i[pointer string string], :string
  attach_function :pactffi_message_pact_get_metadata_iter, %i[pointer], :pointer
  attach_function :pactffi_message_pact_metadata_iter_next, %i[pointer], :pointer
  attach_function :pactffi_message_pact_metadata_iter_delete, %i[pointer], :void
  attach_function :pactffi_message_pact_metadata_triple_delete, %i[pointer], :void
  attach_function :pactffi_provider_get_name, %i[pointer], :string
  attach_function :pactffi_pact_get_provider, %i[pointer], :pointer
  attach_function :pactffi_pact_provider_delete, %i[pointer], :void
  attach_function :pactffi_provider_state_get_name, %i[pointer], :string
  attach_function :pactffi_provider_state_get_param_iter, %i[pointer], :pointer
  attach_function :pactffi_provider_state_param_iter_next, %i[pointer], :pointer
  attach_function :pactffi_provider_state_delete, %i[pointer], :void
  attach_function :pactffi_provider_state_param_iter_delete, %i[pointer], :void
  attach_function :pactffi_provider_state_param_pair_delete, %i[pointer], :void
  attach_function :pactffi_sync_message_new, %i[], :pointer
  attach_function :pactffi_sync_message_delete, %i[pointer], :void
  attach_function :pactffi_sync_message_get_request_contents_str, %i[pointer], :string
  attach_function :pactffi_sync_message_set_request_contents_str, %i[pointer string string], :void
  attach_function :pactffi_sync_message_get_request_contents_length, %i[pointer], :size_t
  attach_function :pactffi_sync_message_get_request_contents_bin, %i[pointer], :pointer
  attach_function :pactffi_sync_message_set_request_contents_bin, %i[pointer pointer size_t string], :void
  attach_function :pactffi_sync_message_get_request_contents, %i[pointer], :pointer
  attach_function :pactffi_sync_message_get_number_responses, %i[pointer], :size_t
  attach_function :pactffi_sync_message_get_response_contents_str, %i[pointer size_t], :string
  attach_function :pactffi_sync_message_set_response_contents_str, %i[pointer size_t string string], :void
  attach_function :pactffi_sync_message_get_response_contents_length, %i[pointer size_t], :size_t
  attach_function :pactffi_sync_message_get_response_contents_bin, %i[pointer size_t], :pointer
  attach_function :pactffi_sync_message_set_response_contents_bin, %i[pointer size_t pointer size_t string], :void
  attach_function :pactffi_sync_message_get_response_contents, %i[pointer size_t], :pointer
  attach_function :pactffi_sync_message_get_description, %i[pointer], :string
  attach_function :pactffi_sync_message_set_description, %i[pointer string], :int32
  attach_function :pactffi_sync_message_get_provider_state, %i[pointer uint32_type], :pointer
  attach_function :pactffi_sync_message_get_provider_state_iter, %i[pointer], :pointer
  attach_function :pactffi_string_delete, %i[string], :void
  attach_function :pactffi_create_mock_server, %i[string string bool], :int32
  attach_function :pactffi_get_tls_ca_certificate, %i[], :string
  attach_function :pactffi_create_mock_server_for_pact, %i[uint16 string bool], :int32
  attach_function :pactffi_create_mock_server_for_transport, %i[uint16 string uint16 string string], :int32
  attach_function :pactffi_mock_server_matched, %i[int32], :bool
  attach_function :pactffi_mock_server_mismatches, %i[int32], :string
  attach_function :pactffi_cleanup_mock_server, %i[int32], :bool
  attach_function :pactffi_write_pact_file, %i[int32 string bool], :int32
  attach_function :pactffi_mock_server_logs, %i[int32], :string
  attach_function :pactffi_generate_datetime_string, %i[string], :pointer
  attach_function :pactffi_check_regex, %i[string string], :bool
  attach_function :pactffi_generate_regex_value, %i[string], :pointer
  attach_function :pactffi_free_string, %i[string], :void
  attach_function :pactffi_new_pact, %i[string string], :uint16
  attach_function :pactffi_new_interaction, %i[uint16 string], :uint32_type
  attach_function :pactffi_new_message_interaction, %i[uint16 string], :uint32_type
  attach_function :pactffi_new_sync_message_interaction, %i[uint16 string], :uint32_type
  attach_function :pactffi_upon_receiving, %i[uint32_type string], :bool
  attach_function :pactffi_given, %i[uint32_type string], :bool
  attach_function :pactffi_interaction_test_name, %i[uint32_type string], :uint32_type
  attach_function :pactffi_given_with_param, %i[uint32_type string string string], :bool
  attach_function :pactffi_with_request, %i[uint32_type string string], :bool
  attach_function :pactffi_with_query_parameter, %i[uint32_type string size_t string], :bool
  attach_function :pactffi_with_query_parameter_v2, %i[uint32_type string size_t string], :bool
  attach_function :pactffi_with_specification, %i[uint16 int32], :bool
  attach_function :pactffi_with_pact_metadata, %i[uint16 string string string], :bool
  attach_function :pactffi_with_header, %i[uint32_type int32 string size_t string], :bool
  attach_function :pactffi_with_header_v2, %i[uint32_type int32 string size_t string], :bool
  attach_function :pactffi_response_status, %i[uint32_type uint16], :bool
  attach_function :pactffi_with_body, %i[uint32_type int32 string string], :bool
  attach_function :pactffi_with_binary_file, %i[uint32_type int32 string pointer size_t], :bool
  attach_function :pactffi_with_multipart_file, %i[uint32_type int32 string string string], :pointer
  attach_function :pactffi_pact_handle_get_message_iter, %i[uint16], :pointer
  attach_function :pactffi_pact_handle_get_sync_message_iter, %i[uint16], :pointer
  attach_function :pactffi_pact_handle_get_sync_http_iter, %i[uint16], :pointer
  attach_function :pactffi_new_message_pact, %i[string string], :uint16
  attach_function :pactffi_new_message, %i[uint16 string], :uint32_type
  attach_function :pactffi_message_expects_to_receive, %i[uint32_type string], :void
  attach_function :pactffi_message_given, %i[uint32_type string], :void
  attach_function :pactffi_message_given_with_param, %i[uint32_type string string string], :void
  attach_function :pactffi_message_with_contents, %i[uint32_type string pointer size_t], :void
  attach_function :pactffi_message_with_metadata, %i[uint32_type string string], :void
  attach_function :pactffi_message_reify, %i[uint32_type], :string
  attach_function :pactffi_write_message_pact_file, %i[uint16 string bool], :int32
  attach_function :pactffi_with_message_pact_metadata, %i[uint16 string string string], :void
  attach_function :pactffi_pact_handle_write_file, %i[uint16 string bool], :int32
  attach_function :pactffi_new_async_message, %i[uint16 string], :uint32_type
  attach_function :pactffi_free_pact_handle, %i[uint16], :uint32_type
  attach_function :pactffi_free_message_pact_handle, %i[uint16], :uint32_type
  attach_function :pactffi_verify, %i[string], :int32
  attach_function :pactffi_verifier_new, %i[], :pointer
  attach_function :pactffi_verifier_new_for_application, %i[string string], :pointer
  attach_function :pactffi_verifier_shutdown, %i[pointer], :void
  attach_function :pactffi_verifier_set_provider_info, %i[pointer string string string uint16 string], :void
  attach_function :pactffi_verifier_add_provider_transport, %i[pointer string uint16 string string], :void
  attach_function :pactffi_verifier_set_filter_info, %i[pointer string string uint8], :void
  attach_function :pactffi_verifier_set_provider_state, %i[pointer string uint8 uint8], :void
  attach_function :pactffi_verifier_set_verification_options, %i[pointer uint8 ulong_long], :int32
  attach_function :pactffi_verifier_set_coloured_output, %i[pointer uint8], :int32
  attach_function :pactffi_verifier_set_no_pacts_is_error, %i[pointer uint8], :int32
  attach_function :pactffi_verifier_set_publish_options, %i[pointer string string pointer uint16 string], :int32
  attach_function :pactffi_verifier_set_consumer_filters, %i[pointer pointer uint16], :void
  attach_function :pactffi_verifier_add_custom_header, %i[pointer string string], :void
  attach_function :pactffi_verifier_add_file_source, %i[pointer string], :void
  attach_function :pactffi_verifier_add_directory_source, %i[pointer string], :void
  attach_function :pactffi_verifier_url_source, %i[pointer string string string string], :void
  attach_function :pactffi_verifier_broker_source, %i[pointer string string string string], :void
  attach_function :pactffi_verifier_broker_source_with_selectors,
                  %i[pointer string string string string uint8 string pointer uint16 string pointer uint16 pointer uint16], :void
  attach_function :pactffi_verifier_execute, %i[pointer], :int32
  attach_function :pactffi_verifier_cli_args, %i[], :string
  attach_function :pactffi_verifier_logs, %i[pointer], :string
  attach_function :pactffi_verifier_logs_for_provider, %i[string], :string
  attach_function :pactffi_verifier_output, %i[pointer uint8], :string
  attach_function :pactffi_verifier_json, %i[pointer], :string
  attach_function :pactffi_using_plugin, %i[uint16 string string], :uint32_type
  attach_function :pactffi_cleanup_plugins, %i[uint16], :void
  attach_function :pactffi_interaction_contents, %i[uint32_type int32 string string], :uint32_type
  attach_function :pactffi_matches_string_value, %i[pointer string string uint8], :string
  attach_function :pactffi_matches_u64_value, %i[pointer ulong_long ulong_long uint8], :string
  attach_function :pactffi_matches_i64_value, %i[pointer int64 int64 uint8], :string
  attach_function :pactffi_matches_f64_value, %i[pointer double double uint8], :string
  attach_function :pactffi_matches_bool_value, %i[pointer uint8 uint8 uint8], :string
  attach_function :pactffi_matches_binary_value, %i[pointer pointer ulong_long pointer ulong_long uint8], :string
  attach_function :pactffi_matches_json_value, %i[pointer string string uint8], :string
end
