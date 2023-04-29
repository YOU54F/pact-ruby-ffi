require 'fiddle'
require_relative 'detect_os'

lib = Fiddle.dlopen(DetectOS.get_bin_path)

pactffi_version = Fiddle::Function.new(
  lib['pactffi_version'],
  [],
  Fiddle::TYPE_VOIDP
)

pactffi_init = Fiddle::Function.new(
  lib['pactffi_init'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_init_with_log_level = Fiddle::Function.new(
  lib['pactffi_init_with_log_level'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_enable_ansi_support = Fiddle::Function.new(
  lib['pactffi_enable_ansi_support'],
  [],
  Fiddle::TYPE_VOID
)
pactffi_log_message = Fiddle::Function.new(
  lib['pactffi_log_message'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_match_message = Fiddle::Function.new(
  lib['pactffi_match_message'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_mismatches_get_iter = Fiddle::Function.new(
  lib['pactffi_mismatches_get_iter'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_mismatches_delete = Fiddle::Function.new(
  lib['pactffi_mismatches_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_mismatches_iter_next = Fiddle::Function.new(
  lib['pactffi_mismatches_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_mismatches_iter_delete = Fiddle::Function.new(
  lib['pactffi_mismatches_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_mismatch_to_json = Fiddle::Function.new(
  lib['pactffi_mismatch_to_json'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_mismatch_type = Fiddle::Function.new(
  lib['pactffi_mismatch_type'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_mismatch_summary = Fiddle::Function.new(
  lib['pactffi_mismatch_summary'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_mismatch_description = Fiddle::Function.new(
  lib['pactffi_mismatch_description'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_mismatch_ansi_description = Fiddle::Function.new(
  lib['pactffi_mismatch_ansi_description'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_get_error_message = Fiddle::Function.new(
  lib['pactffi_get_error_message'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INT32_T
)
pactffi_log_to_stdout = Fiddle::Function.new(
  lib['pactffi_log_to_stdout'],
  [Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INT32_T
)
pactffi_log_to_stderr = Fiddle::Function.new(
  lib['pactffi_log_to_stderr'],
  [Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INT32_T
)
pactffi_log_to_file = Fiddle::Function.new(
  lib['pactffi_log_to_file'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INT32_T
)
pactffi_log_to_buffer = Fiddle::Function.new(
  lib['pactffi_log_to_buffer'],
  [Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INT32_T
)
pactffi_logger_init = Fiddle::Function.new(
  lib['pactffi_logger_init'],
  [],
  Fiddle::TYPE_VOID
)
pactffi_logger_attach_sink = Fiddle::Function.new(
  lib['pactffi_logger_attach_sink'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INT32_T
)
pactffi_logger_apply = Fiddle::Function.new(
  lib['pactffi_logger_apply'],
  [],
  Fiddle::TYPE_INT32_T
)
pactffi_fetch_log_buffer = Fiddle::Function.new(
  lib['pactffi_fetch_log_buffer'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOIDP
)
pactffi_parse_pact_json = Fiddle::Function.new(
  lib['pactffi_parse_pact_json'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_model_delete = Fiddle::Function.new(
  lib['pactffi_pact_model_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_pact_model_interaction_iterator = Fiddle::Function.new(
  lib['pactffi_pact_model_interaction_iterator'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_spec_version = Fiddle::Function.new(
  lib['pactffi_pact_spec_version'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INT32_T
)
pactffi_pact_interaction_delete = Fiddle::Function.new(
  lib['pactffi_pact_interaction_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_async_message_new = Fiddle::Function.new(
  lib['pactffi_async_message_new'],
  [],
  Fiddle::TYPE_INTPTR_T
)
pactffi_async_message_delete = Fiddle::Function.new(
  lib['pactffi_async_message_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_async_message_get_contents = Fiddle::Function.new(
  lib['pactffi_async_message_get_contents'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_async_message_get_contents_str = Fiddle::Function.new(
  lib['pactffi_async_message_get_contents_str'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_async_message_set_contents_str = Fiddle::Function.new(
  lib['pactffi_async_message_set_contents_str'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_async_message_get_contents_length = Fiddle::Function.new(
  lib['pactffi_async_message_get_contents_length'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_SIZE_T
)
pactffi_async_message_get_contents_bin = Fiddle::Function.new(
  lib['pactffi_async_message_get_contents_bin'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_async_message_set_contents_bin = Fiddle::Function.new(
  lib['pactffi_async_message_set_contents_bin'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_async_message_get_description = Fiddle::Function.new(
  lib['pactffi_async_message_get_description'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_async_message_set_description = Fiddle::Function.new(
  lib['pactffi_async_message_set_description'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT32_T
)
pactffi_async_message_get_provider_state = Fiddle::Function.new(
  lib['pactffi_async_message_get_provider_state'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT32_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_async_message_get_provider_state_iter = Fiddle::Function.new(
  lib['pactffi_async_message_get_provider_state_iter'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_consumer_get_name = Fiddle::Function.new(
  lib['pactffi_consumer_get_name'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_pact_get_consumer = Fiddle::Function.new(
  lib['pactffi_pact_get_consumer'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_consumer_delete = Fiddle::Function.new(
  lib['pactffi_pact_consumer_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_message_contents_get_contents_str = Fiddle::Function.new(
  lib['pactffi_message_contents_get_contents_str'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_message_contents_set_contents_str = Fiddle::Function.new(
  lib['pactffi_message_contents_set_contents_str'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_message_contents_get_contents_length = Fiddle::Function.new(
  lib['pactffi_message_contents_get_contents_length'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_SIZE_T
)
pactffi_message_contents_get_contents_bin = Fiddle::Function.new(
  lib['pactffi_message_contents_get_contents_bin'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_contents_set_contents_bin = Fiddle::Function.new(
  lib['pactffi_message_contents_set_contents_bin'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_message_contents_get_metadata_iter = Fiddle::Function.new(
  lib['pactffi_message_contents_get_metadata_iter'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_contents_get_matching_rule_iter = Fiddle::Function.new(
  lib['pactffi_message_contents_get_matching_rule_iter'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_request_contents_get_matching_rule_iter = Fiddle::Function.new(
  lib['pactffi_request_contents_get_matching_rule_iter'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_response_contents_get_matching_rule_iter = Fiddle::Function.new(
  lib['pactffi_response_contents_get_matching_rule_iter'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_contents_get_generators_iter = Fiddle::Function.new(
  lib['pactffi_message_contents_get_generators_iter'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_request_contents_get_generators_iter = Fiddle::Function.new(
  lib['pactffi_request_contents_get_generators_iter'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_response_contents_get_generators_iter = Fiddle::Function.new(
  lib['pactffi_response_contents_get_generators_iter'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_parse_matcher_definition = Fiddle::Function.new(
  lib['pactffi_parse_matcher_definition'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INTPTR_T
)
pactffi_matcher_definition_error = Fiddle::Function.new(
  lib['pactffi_matcher_definition_error'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_matcher_definition_value = Fiddle::Function.new(
  lib['pactffi_matcher_definition_value'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_matcher_definition_delete = Fiddle::Function.new(
  lib['pactffi_matcher_definition_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_matcher_definition_generator = Fiddle::Function.new(
  lib['pactffi_matcher_definition_generator'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_matcher_definition_value_type = Fiddle::Function.new(
  lib['pactffi_matcher_definition_value_type'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INT32_T
)
pactffi_matching_rule_iter_delete = Fiddle::Function.new(
  lib['pactffi_matching_rule_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_matcher_definition_iter = Fiddle::Function.new(
  lib['pactffi_matcher_definition_iter'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_matching_rule_iter_next = Fiddle::Function.new(
  lib['pactffi_matching_rule_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_matching_rule_id = Fiddle::Function.new(
  lib['pactffi_matching_rule_id'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_UINT16_T
)
pactffi_matching_rule_value = Fiddle::Function.new(
  lib['pactffi_matching_rule_value'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_matching_rule_pointer = Fiddle::Function.new(
  lib['pactffi_matching_rule_pointer'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_matching_rule_reference_name = Fiddle::Function.new(
  lib['pactffi_matching_rule_reference_name'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_validate_datetime = Fiddle::Function.new(
  lib['pactffi_validate_datetime'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT32_T
)
pactffi_generator_to_json = Fiddle::Function.new(
  lib['pactffi_generator_to_json'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_generator_generate_string = Fiddle::Function.new(
  lib['pactffi_generator_generate_string'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOIDP
)
pactffi_generator_generate_integer = Fiddle::Function.new(
  lib['pactffi_generator_generate_integer'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_UINT16_T
)
pactffi_generators_iter_delete = Fiddle::Function.new(
  lib['pactffi_generators_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_generators_iter_next = Fiddle::Function.new(
  lib['pactffi_generators_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_generators_iter_pair_delete = Fiddle::Function.new(
  lib['pactffi_generators_iter_pair_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_sync_http_new = Fiddle::Function.new(
  lib['pactffi_sync_http_new'],
  [],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_http_delete = Fiddle::Function.new(
  lib['pactffi_sync_http_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_sync_http_get_request = Fiddle::Function.new(
  lib['pactffi_sync_http_get_request'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_http_get_request_contents = Fiddle::Function.new(
  lib['pactffi_sync_http_get_request_contents'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_sync_http_set_request_contents = Fiddle::Function.new(
  lib['pactffi_sync_http_set_request_contents'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_sync_http_get_request_contents_length = Fiddle::Function.new(
  lib['pactffi_sync_http_get_request_contents_length'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_SIZE_T
)
pactffi_sync_http_get_request_contents_bin = Fiddle::Function.new(
  lib['pactffi_sync_http_get_request_contents_bin'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_http_set_request_contents_bin = Fiddle::Function.new(
  lib['pactffi_sync_http_set_request_contents_bin'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_sync_http_get_response = Fiddle::Function.new(
  lib['pactffi_sync_http_get_response'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_http_get_response_contents = Fiddle::Function.new(
  lib['pactffi_sync_http_get_response_contents'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_sync_http_set_response_contents = Fiddle::Function.new(
  lib['pactffi_sync_http_set_response_contents'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_sync_http_get_response_contents_length = Fiddle::Function.new(
  lib['pactffi_sync_http_get_response_contents_length'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_SIZE_T
)
pactffi_sync_http_get_response_contents_bin = Fiddle::Function.new(
  lib['pactffi_sync_http_get_response_contents_bin'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_http_set_response_contents_bin = Fiddle::Function.new(
  lib['pactffi_sync_http_set_response_contents_bin'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_sync_http_get_description = Fiddle::Function.new(
  lib['pactffi_sync_http_get_description'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_sync_http_set_description = Fiddle::Function.new(
  lib['pactffi_sync_http_set_description'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT32_T
)
pactffi_sync_http_get_provider_state = Fiddle::Function.new(
  lib['pactffi_sync_http_get_provider_state'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT32_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_http_get_provider_state_iter = Fiddle::Function.new(
  lib['pactffi_sync_http_get_provider_state_iter'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_interaction_as_synchronous_http = Fiddle::Function.new(
  lib['pactffi_pact_interaction_as_synchronous_http'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_interaction_as_message = Fiddle::Function.new(
  lib['pactffi_pact_interaction_as_message'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_interaction_as_asynchronous_message = Fiddle::Function.new(
  lib['pactffi_pact_interaction_as_asynchronous_message'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_interaction_as_synchronous_message = Fiddle::Function.new(
  lib['pactffi_pact_interaction_as_synchronous_message'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_message_iter_delete = Fiddle::Function.new(
  lib['pactffi_pact_message_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_pact_message_iter_next = Fiddle::Function.new(
  lib['pactffi_pact_message_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_sync_message_iter_next = Fiddle::Function.new(
  lib['pactffi_pact_sync_message_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_sync_message_iter_delete = Fiddle::Function.new(
  lib['pactffi_pact_sync_message_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_pact_sync_http_iter_next = Fiddle::Function.new(
  lib['pactffi_pact_sync_http_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_sync_http_iter_delete = Fiddle::Function.new(
  lib['pactffi_pact_sync_http_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_pact_interaction_iter_next = Fiddle::Function.new(
  lib['pactffi_pact_interaction_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_interaction_iter_delete = Fiddle::Function.new(
  lib['pactffi_pact_interaction_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_matching_rule_to_json = Fiddle::Function.new(
  lib['pactffi_matching_rule_to_json'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_matching_rules_iter_delete = Fiddle::Function.new(
  lib['pactffi_matching_rules_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_matching_rules_iter_next = Fiddle::Function.new(
  lib['pactffi_matching_rules_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_matching_rules_iter_pair_delete = Fiddle::Function.new(
  lib['pactffi_matching_rules_iter_pair_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_message_new = Fiddle::Function.new(
  lib['pactffi_message_new'],
  [],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_new_from_json = Fiddle::Function.new(
  lib['pactffi_message_new_from_json'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_new_from_body = Fiddle::Function.new(
  lib['pactffi_message_new_from_body'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_delete = Fiddle::Function.new(
  lib['pactffi_message_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_message_get_contents = Fiddle::Function.new(
  lib['pactffi_message_get_contents'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_message_set_contents = Fiddle::Function.new(
  lib['pactffi_message_set_contents'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_message_get_contents_length = Fiddle::Function.new(
  lib['pactffi_message_get_contents_length'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_SIZE_T
)
pactffi_message_get_contents_bin = Fiddle::Function.new(
  lib['pactffi_message_get_contents_bin'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_set_contents_bin = Fiddle::Function.new(
  lib['pactffi_message_set_contents_bin'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_message_get_description = Fiddle::Function.new(
  lib['pactffi_message_get_description'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_message_set_description = Fiddle::Function.new(
  lib['pactffi_message_set_description'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT32_T
)
pactffi_message_get_provider_state = Fiddle::Function.new(
  lib['pactffi_message_get_provider_state'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT32_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_get_provider_state_iter = Fiddle::Function.new(
  lib['pactffi_message_get_provider_state_iter'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_provider_state_iter_next = Fiddle::Function.new(
  lib['pactffi_provider_state_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_provider_state_iter_delete = Fiddle::Function.new(
  lib['pactffi_provider_state_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_message_find_metadata = Fiddle::Function.new(
  lib['pactffi_message_find_metadata'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOIDP
)
pactffi_message_insert_metadata = Fiddle::Function.new(
  lib['pactffi_message_insert_metadata'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT32_T
)
pactffi_message_metadata_iter_next = Fiddle::Function.new(
  lib['pactffi_message_metadata_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_get_metadata_iter = Fiddle::Function.new(
  lib['pactffi_message_get_metadata_iter'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_metadata_iter_delete = Fiddle::Function.new(
  lib['pactffi_message_metadata_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_message_metadata_pair_delete = Fiddle::Function.new(
  lib['pactffi_message_metadata_pair_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_message_pact_new_from_json = Fiddle::Function.new(
  lib['pactffi_message_pact_new_from_json'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_pact_delete = Fiddle::Function.new(
  lib['pactffi_message_pact_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_message_pact_get_consumer = Fiddle::Function.new(
  lib['pactffi_message_pact_get_consumer'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_pact_get_provider = Fiddle::Function.new(
  lib['pactffi_message_pact_get_provider'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_pact_get_message_iter = Fiddle::Function.new(
  lib['pactffi_message_pact_get_message_iter'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_pact_message_iter_next = Fiddle::Function.new(
  lib['pactffi_message_pact_message_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_pact_message_iter_delete = Fiddle::Function.new(
  lib['pactffi_message_pact_message_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_message_pact_find_metadata = Fiddle::Function.new(
  lib['pactffi_message_pact_find_metadata'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOIDP
)
pactffi_message_pact_get_metadata_iter = Fiddle::Function.new(
  lib['pactffi_message_pact_get_metadata_iter'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_pact_metadata_iter_next = Fiddle::Function.new(
  lib['pactffi_message_pact_metadata_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_message_pact_metadata_iter_delete = Fiddle::Function.new(
  lib['pactffi_message_pact_metadata_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_message_pact_metadata_triple_delete = Fiddle::Function.new(
  lib['pactffi_message_pact_metadata_triple_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_provider_get_name = Fiddle::Function.new(
  lib['pactffi_provider_get_name'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_pact_get_provider = Fiddle::Function.new(
  lib['pactffi_pact_get_provider'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_provider_delete = Fiddle::Function.new(
  lib['pactffi_pact_provider_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_provider_state_get_name = Fiddle::Function.new(
  lib['pactffi_provider_state_get_name'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_provider_state_get_param_iter = Fiddle::Function.new(
  lib['pactffi_provider_state_get_param_iter'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_provider_state_param_iter_next = Fiddle::Function.new(
  lib['pactffi_provider_state_param_iter_next'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_provider_state_delete = Fiddle::Function.new(
  lib['pactffi_provider_state_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_provider_state_param_iter_delete = Fiddle::Function.new(
  lib['pactffi_provider_state_param_iter_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_provider_state_param_pair_delete = Fiddle::Function.new(
  lib['pactffi_provider_state_param_pair_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_sync_message_new = Fiddle::Function.new(
  lib['pactffi_sync_message_new'],
  [],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_message_delete = Fiddle::Function.new(
  lib['pactffi_sync_message_delete'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_sync_message_get_request_contents_str = Fiddle::Function.new(
  lib['pactffi_sync_message_get_request_contents_str'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_sync_message_set_request_contents_str = Fiddle::Function.new(
  lib['pactffi_sync_message_set_request_contents_str'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_sync_message_get_request_contents_length = Fiddle::Function.new(
  lib['pactffi_sync_message_get_request_contents_length'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_SIZE_T
)
pactffi_sync_message_get_request_contents_bin = Fiddle::Function.new(
  lib['pactffi_sync_message_get_request_contents_bin'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_message_set_request_contents_bin = Fiddle::Function.new(
  lib['pactffi_sync_message_set_request_contents_bin'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_sync_message_get_request_contents = Fiddle::Function.new(
  lib['pactffi_sync_message_get_request_contents'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_message_get_number_responses = Fiddle::Function.new(
  lib['pactffi_sync_message_get_number_responses'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_SIZE_T
)
pactffi_sync_message_get_response_contents_str = Fiddle::Function.new(
  lib['pactffi_sync_message_get_response_contents_str'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T],
  Fiddle::TYPE_VOIDP
)
pactffi_sync_message_set_response_contents_str = Fiddle::Function.new(
  lib['pactffi_sync_message_set_response_contents_str'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_sync_message_get_response_contents_length = Fiddle::Function.new(
  lib['pactffi_sync_message_get_response_contents_length'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T],
  Fiddle::TYPE_SIZE_T
)
pactffi_sync_message_get_response_contents_bin = Fiddle::Function.new(
  lib['pactffi_sync_message_get_response_contents_bin'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_message_set_response_contents_bin = Fiddle::Function.new(
  lib['pactffi_sync_message_set_response_contents_bin'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_sync_message_get_response_contents = Fiddle::Function.new(
  lib['pactffi_sync_message_get_response_contents'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_message_get_description = Fiddle::Function.new(
  lib['pactffi_sync_message_get_description'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_sync_message_set_description = Fiddle::Function.new(
  lib['pactffi_sync_message_set_description'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT32_T
)
pactffi_sync_message_get_provider_state = Fiddle::Function.new(
  lib['pactffi_sync_message_get_provider_state'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT32_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_sync_message_get_provider_state_iter = Fiddle::Function.new(
  lib['pactffi_sync_message_get_provider_state_iter'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_string_delete = Fiddle::Function.new(
  lib['pactffi_string_delete'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_create_mock_server = Fiddle::Function.new(
  lib['pactffi_create_mock_server'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
  Fiddle::TYPE_INT32_T
)
pactffi_get_tls_ca_certificate = Fiddle::Function.new(
  lib['pactffi_get_tls_ca_certificate'],
  [],
  Fiddle::TYPE_VOIDP
)
pactffi_create_mock_server_for_pact = Fiddle::Function.new(
  lib['pactffi_create_mock_server_for_pact'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
  Fiddle::TYPE_INT32_T
)
pactffi_create_mock_server_for_transport = Fiddle::Function.new(
  lib['pactffi_create_mock_server_for_transport'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT32_T
)
pactffi_mock_server_matched = Fiddle::Function.new(
  lib['pactffi_mock_server_matched'],
  [Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INT
)
pactffi_mock_server_mismatches = Fiddle::Function.new(
  lib['pactffi_mock_server_mismatches'],
  [Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_VOIDP
)
pactffi_cleanup_mock_server = Fiddle::Function.new(
  lib['pactffi_cleanup_mock_server'],
  [Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INT
)
pactffi_write_pact_file = Fiddle::Function.new(
  lib['pactffi_write_pact_file'],
  [Fiddle::TYPE_INT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
  Fiddle::TYPE_INT32_T
)
pactffi_mock_server_logs = Fiddle::Function.new(
  lib['pactffi_mock_server_logs'],
  [Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_VOIDP
)
pactffi_generate_datetime_string = Fiddle::Function.new(
  lib['pactffi_generate_datetime_string'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOIDP
)
pactffi_check_regex = Fiddle::Function.new(
  lib['pactffi_check_regex'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
)
pactffi_generate_regex_value = Fiddle::Function.new(
  lib['pactffi_generate_regex_value'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOIDP
)
pactffi_free_string = Fiddle::Function.new(
  lib['pactffi_free_string'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_new_pact = Fiddle::Function.new(
  lib['pactffi_new_pact'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_UINT16_T
)
pactffi_new_interaction = Fiddle::Function.new(
  lib['pactffi_new_interaction'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_UINT32_T
)
pactffi_new_message_interaction = Fiddle::Function.new(
  lib['pactffi_new_message_interaction'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_UINT32_T
)
pactffi_new_sync_message_interaction = Fiddle::Function.new(
  lib['pactffi_new_sync_message_interaction'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_UINT32_T
)
pactffi_upon_receiving = Fiddle::Function.new(
  lib['pactffi_upon_receiving'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
)
pactffi_given = Fiddle::Function.new(
  lib['pactffi_given'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
)
pactffi_interaction_test_name = Fiddle::Function.new(
  lib['pactffi_interaction_test_name'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_UINT32_T
)
pactffi_given_with_param = Fiddle::Function.new(
  lib['pactffi_given_with_param'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
)
pactffi_with_request = Fiddle::Function.new(
  lib['pactffi_with_request'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
)
pactffi_with_query_parameter = Fiddle::Function.new(
  lib['pactffi_with_query_parameter'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
)
pactffi_with_query_parameter_v2 = Fiddle::Function.new(
  lib['pactffi_with_query_parameter_v2'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
)
pactffi_with_specification = Fiddle::Function.new(
  lib['pactffi_with_specification'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_INT32_T],
  Fiddle::TYPE_INT
)
pactffi_with_pact_metadata = Fiddle::Function.new(
  lib['pactffi_with_pact_metadata'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
)
pactffi_with_header = Fiddle::Function.new(
  lib['pactffi_with_header'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_INT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
)
pactffi_with_header_v2 = Fiddle::Function.new(
  lib['pactffi_with_header_v2'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_INT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_SIZE_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
)
pactffi_response_status = Fiddle::Function.new(
  lib['pactffi_response_status'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_UINT16_T],
  Fiddle::TYPE_INT
)
pactffi_with_body = Fiddle::Function.new(
  lib['pactffi_with_body'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_INT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
)
pactffi_with_binary_file = Fiddle::Function.new(
  lib['pactffi_with_binary_file'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_INT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T],
  Fiddle::TYPE_INT
)
pactffi_with_multipart_file = Fiddle::Function.new(
  lib['pactffi_with_multipart_file'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_INT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOIDP
)
pactffi_pact_handle_get_message_iter = Fiddle::Function.new(
  lib['pactffi_pact_handle_get_message_iter'],
  [Fiddle::TYPE_UINT16_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_handle_get_sync_message_iter = Fiddle::Function.new(
  lib['pactffi_pact_handle_get_sync_message_iter'],
  [Fiddle::TYPE_UINT16_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_pact_handle_get_sync_http_iter = Fiddle::Function.new(
  lib['pactffi_pact_handle_get_sync_http_iter'],
  [Fiddle::TYPE_UINT16_T],
  Fiddle::TYPE_INTPTR_T
)
pactffi_new_message_pact = Fiddle::Function.new(
  lib['pactffi_new_message_pact'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_UINT16_T
)
pactffi_new_message = Fiddle::Function.new(
  lib['pactffi_new_message'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_UINT32_T
)
pactffi_message_expects_to_receive = Fiddle::Function.new(
  lib['pactffi_message_expects_to_receive'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_message_given = Fiddle::Function.new(
  lib['pactffi_message_given'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_message_given_with_param = Fiddle::Function.new(
  lib['pactffi_message_given_with_param'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_message_with_contents = Fiddle::Function.new(
  lib['pactffi_message_with_contents'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_SIZE_T],
  Fiddle::TYPE_VOID
)
pactffi_message_with_metadata = Fiddle::Function.new(
  lib['pactffi_message_with_metadata'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_message_reify = Fiddle::Function.new(
  lib['pactffi_message_reify'],
  [Fiddle::TYPE_UINT32_T],
  Fiddle::TYPE_VOIDP
)
pactffi_write_message_pact_file = Fiddle::Function.new(
  lib['pactffi_write_message_pact_file'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
  Fiddle::TYPE_INT32_T
)
pactffi_with_message_pact_metadata = Fiddle::Function.new(
  lib['pactffi_with_message_pact_metadata'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_pact_handle_write_file = Fiddle::Function.new(
  lib['pactffi_pact_handle_write_file'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
  Fiddle::TYPE_INT32_T
)
pactffi_new_async_message = Fiddle::Function.new(
  lib['pactffi_new_async_message'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_UINT32_T
)
pactffi_free_pact_handle = Fiddle::Function.new(
  lib['pactffi_free_pact_handle'],
  [Fiddle::TYPE_UINT16_T],
  Fiddle::TYPE_UINT32_T
)
pactffi_free_message_pact_handle = Fiddle::Function.new(
  lib['pactffi_free_message_pact_handle'],
  [Fiddle::TYPE_UINT16_T],
  Fiddle::TYPE_UINT32_T
)
pactffi_verify = Fiddle::Function.new(
  lib['pactffi_verify'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT32_T
)
pactffi_verifier_new = Fiddle::Function.new(
  lib['pactffi_verifier_new'],
  [],
  Fiddle::TYPE_INTPTR_T
)
pactffi_verifier_new_for_application = Fiddle::Function.new(
  lib['pactffi_verifier_new_for_application'],
  [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INTPTR_T
)
pactffi_verifier_shutdown = Fiddle::Function.new(
  lib['pactffi_verifier_shutdown'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOID
)
pactffi_verifier_set_provider_info = Fiddle::Function.new(
  lib['pactffi_verifier_set_provider_info'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_UINT16_T,
   Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_verifier_add_provider_transport = Fiddle::Function.new(
  lib['pactffi_verifier_add_provider_transport'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_verifier_set_filter_info = Fiddle::Function.new(
  lib['pactffi_verifier_set_filter_info'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_VOID
)
pactffi_verifier_set_provider_state = Fiddle::Function.new(
  lib['pactffi_verifier_set_provider_state'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_UINT8_T, Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_VOID
)
pactffi_verifier_set_verification_options = Fiddle::Function.new(
  lib['pactffi_verifier_set_verification_options'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT8_T, Fiddle::TYPE_LONG],
  Fiddle::TYPE_INT32_T
)
pactffi_verifier_set_coloured_output = Fiddle::Function.new(
  lib['pactffi_verifier_set_coloured_output'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_INT32_T
)
pactffi_verifier_set_no_pacts_is_error = Fiddle::Function.new(
  lib['pactffi_verifier_set_no_pacts_is_error'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_INT32_T
)
pactffi_verifier_set_publish_options = Fiddle::Function.new(
  lib['pactffi_verifier_set_publish_options'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT16_T,
   Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT32_T
)
pactffi_verifier_set_consumer_filters = Fiddle::Function.new(
  lib['pactffi_verifier_set_consumer_filters'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT16_T],
  Fiddle::TYPE_VOID
)
pactffi_verifier_add_custom_header = Fiddle::Function.new(
  lib['pactffi_verifier_add_custom_header'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_verifier_add_file_source = Fiddle::Function.new(
  lib['pactffi_verifier_add_file_source'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_verifier_add_directory_source = Fiddle::Function.new(
  lib['pactffi_verifier_add_directory_source'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_verifier_url_source = Fiddle::Function.new(
  lib['pactffi_verifier_url_source'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_verifier_broker_source = Fiddle::Function.new(
  lib['pactffi_verifier_broker_source'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOID
)
pactffi_verifier_broker_source_with_selectors = Fiddle::Function.new(
  lib['pactffi_verifier_broker_source_with_selectors'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP,
   Fiddle::TYPE_UINT8_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT16_T, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT16_T],
  Fiddle::TYPE_VOID
)
pactffi_verifier_execute = Fiddle::Function.new(
  lib['pactffi_verifier_execute'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_INT32_T
)
pactffi_verifier_cli_args = Fiddle::Function.new(
  lib['pactffi_verifier_cli_args'],
  [],
  Fiddle::TYPE_VOIDP
)
pactffi_verifier_logs = Fiddle::Function.new(
  lib['pactffi_verifier_logs'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_verifier_logs_for_provider = Fiddle::Function.new(
  lib['pactffi_verifier_logs_for_provider'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOIDP
)
pactffi_verifier_output = Fiddle::Function.new(
  lib['pactffi_verifier_output'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_VOIDP
)
pactffi_verifier_json = Fiddle::Function.new(
  lib['pactffi_verifier_json'],
  [Fiddle::TYPE_INTPTR_T],
  Fiddle::TYPE_VOIDP
)
pactffi_using_plugin = Fiddle::Function.new(
  lib['pactffi_using_plugin'],
  [Fiddle::TYPE_UINT16_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_UINT32_T
)
pactffi_cleanup_plugins = Fiddle::Function.new(
  lib['pactffi_cleanup_plugins'],
  [Fiddle::TYPE_UINT16_T],
  Fiddle::TYPE_VOID
)
pactffi_interaction_contents = Fiddle::Function.new(
  lib['pactffi_interaction_contents'],
  [Fiddle::TYPE_UINT32_T, Fiddle::TYPE_INT32_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_UINT32_T
)
pactffi_matches_string_value = Fiddle::Function.new(
  lib['pactffi_matches_string_value'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_VOIDP
)
pactffi_matches_u64_value = Fiddle::Function.new(
  lib['pactffi_matches_u64_value'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_LONG, Fiddle::TYPE_LONG, Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_VOIDP
)
pactffi_matches_i64_value = Fiddle::Function.new(
  lib['pactffi_matches_i64_value'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_LONG, Fiddle::TYPE_LONG, Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_VOIDP
)
pactffi_matches_f64_value = Fiddle::Function.new(
  lib['pactffi_matches_f64_value'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_DOUBLE, Fiddle::TYPE_DOUBLE, Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_VOIDP
)
pactffi_matches_bool_value = Fiddle::Function.new(
  lib['pactffi_matches_bool_value'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_UINT8_T, Fiddle::TYPE_UINT8_T, Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_VOIDP
)
pactffi_matches_binary_value = Fiddle::Function.new(
  lib['pactffi_matches_binary_value'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_LONG, Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_LONG,
   Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_VOIDP
)
pactffi_matches_json_value = Fiddle::Function.new(
  lib['pactffi_matches_json_value'],
  [Fiddle::TYPE_INTPTR_T, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_UINT8_T],
  Fiddle::TYPE_VOIDP
)

puts pactffi_version.call
