require 'httparty'
require 'pact_ruby_ffi'

RSpec.describe 'pactffi verifier spec' do
  describe 'with mismatching requests' do
    before do
      PactRubyFfi.pactffi_logger_init
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactRubyFfi.pactffi_logger_attach_sink('file ./logs/log-error.txt',
                                             PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      PactRubyFfi.pactffi_logger_attach_sink('stdout', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactRubyFfi.pactffi_logger_attach_sink('stderr', PactRubyFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      PactRubyFfi.pactffi_logger_apply
      # PactRubyFfi.pactffi_init(PactRubyFfi::FfiLogLevel['LOG_LEVEL_INFO'])
    end
    after do
      PactRubyFfi.pactffi_verifier_shutdown(verifier)
    end
    let(:verifier) { PactRubyFfi.pactffi_verifier_new_for_application('pact-ruby', '1.0.0') }
    it 'executes the pact verifier with no information and fails 1' do
      skip
      PactRubyFfi.pactffi_verifier_set_provider_info(verifier, 'http-provider', 'http', '127.0.0.1', 8000, '/')
      result = PactRubyFfi.pactffi_verifier_execute(verifier)
      expect(result).not_to be PactRubyFfi::FfiVerifyProviderResponse['VERIFICATION_SUCCESSFUL']
    end
    it 'executes the pact verifier with no information and fails 2' do
      skip
      PactRubyFfi.pactffi_verifier_set_filter_info(verifier, '', 'book', false)
      PactRubyFfi.pactffi_verifier_set_provider_state(verifier, 'http://127.0.0.1:8000/change-state', true, true)
      PactRubyFfi.pactffi_verifier_set_verification_options(verifier, false, 5000)
      PactRubyFfi.pactffi_verifier_set_publish_options(verifier, '1.0.0', nil, nil, 0, 'some-branch')
      # ffi.pactffi_verifier_set_publish_options(handle, '1.0.0', nil,tags, tags.length, 'some-branch');
      PactRubyFfi.pactffi_verifier_set_consumer_filters(verifier, nil, 0)
      # ffi.pactffi_verifier_set_consumer_filters(handle, getCData(consumers), count(consumers));

      ffi.pactffi_verifier_add_file_source(verifier,
                                           '/Users/saf/dev/pact-foundation/pact-reference/ruby/ruby_ffi/pact/http-consumer-1-http-provider.json')
      result = PactRubyFfi.pactffi_verifier_execute(verifier)
      puts PactRubyFfi.pactffi_verifier_logs(verifier)
      expect(result).not_to be PactRubyFfi::FfiVerifyProviderResponse['VERIFICATION_SUCCESSFUL']
    end
    it 'executes the pact verifier with no information and fails 3' do
      skip
      PactRubyFfi.pactffi_verifier_set_filter_info(verifier, '', 'book', false)
      PactRubyFfi.pactffi_verifier_set_provider_state(verifier, 'http://127.0.0.1:8000/change-state', true, true)
      PactRubyFfi.pactffi_verifier_set_verification_options(verifier, false, 5000)
      PactRubyFfi.pactffi_verifier_set_publish_options(verifier, '1.0.0', nil, nil, 0, 'some-branch')
      # ffi.pactffi_verifier_set_publish_options(handle, '1.0.0', nil,tags, tags.length, 'some-branch');
      PactRubyFfi.pactffi_verifier_set_consumer_filters(verifier, nil, 0)
      # ffi.pactffi_verifier_set_consumer_filters(handle, getCData(consumers), count(consumers));
      local_pact = '/Users/saf/dev/pact-foundation/pact-reference/ruby/ruby_ffi/pact_ruby_ffi/pacts/http-consumer-1-http-provider.json'
      PactRubyFfi.pactffi_verifier_add_file_source(verifier, local_pact)

      result = PactRubyFfi.pactffi_verifier_execute(verifier)
      puts PactRubyFfi.pactffi_verifier_logs(verifier)
      expect(result).not_to be PactRubyFfi::FfiVerifyProviderResponse['VERIFICATION_SUCCESSFUL']
    end
  end
end

# /*
#  * | Error | Description |
#  * |-------|-------------|
#  * | 1 | The verification process failed, see output for errors |
#  * | 2 | A null pointer was received |
#  * | 3 | The method panicked |
#  * | 4 | Invalid arguments were provided to the verification process |
#  */
# FfiVerifyProviderResponse = Hash[
#   "VERIFICATION_SUCCESSFUL" => 0,
#   "VERIFICATION_FAILED" => 1,
#   "NULL_POINTER_RECEIVED" => 2,
#   "METHOD_PANICKED" => 3,
#   "INVALID_ARGUMENTS" => 4,
# ]
