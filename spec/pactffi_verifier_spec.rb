require 'httparty'
require 'pact/ffi'
require 'fileutils'

RSpec.describe 'pactffi verifier spec' do
  describe 'with mismatching requests', :skip  do
    before do
      PactFfi.pactffi_logger_init
      FileUtils.mkdir_p 'logs' unless File.directory?('logs')
      PactFfi.pactffi_logger_attach_sink('file ./logs/log.txt',
                                             PactFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactFfi.pactffi_logger_attach_sink('file ./logs/log-error.txt',
                                             PactFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      PactFfi.pactffi_logger_attach_sink('stdout', PactFfi::FfiLogLevelFilter['LOG_LEVEL_INFO'])
      PactFfi.pactffi_logger_attach_sink('stderr', PactFfi::FfiLogLevelFilter['LOG_LEVEL_DEBUG'])
      PactFfi.pactffi_logger_apply
      # PactFfi.pactffi_init(PactFfi::FfiLogLevel['LOG_LEVEL_INFO'])
    end
    after do
      PactFfi.pactffi_verifier_shutdown(verifier)
    end
    let(:verifier) { PactFfi.pactffi_verifier_new_for_application('pact-ruby', '1.0.0') }
    it 'executes the pact verifier with no information and fails 1' do
      PactFfi.pactffi_verifier_set_provider_info(verifier, 'http-provider', 'http', '127.0.0.1', 8000, '/')
      result = PactFfi.pactffi_verifier_execute(verifier)
      expect(result).not_to be PactFfi::FfiVerifyProviderResponse['VERIFICATION_SUCCESSFUL']
    end
    it 'executes the pact verifier with no information and fails 2' do
      PactFfi.pactffi_verifier_set_filter_info(verifier, '', 'book', false)
      PactFfi.pactffi_verifier_set_provider_state(verifier, 'http://127.0.0.1:8000/change-state', true, true)
      PactFfi.pactffi_verifier_set_verification_options(verifier, false, 5000)
      PactFfi.pactffi_verifier_set_publish_options(verifier, '1.0.0', nil, nil, 0, 'some-branch')
      # ffi.pactffi_verifier_set_publish_options(handle, '1.0.0', nil,tags, tags.length, 'some-branch');
      PactFfi.pactffi_verifier_set_consumer_filters(verifier, nil, 0)
      # ffi.pactffi_verifier_set_consumer_filters(handle, getCData(consumers), count(consumers));

      ffi.pactffi_verifier_add_file_source(verifier,
                                           '/Users/saf/dev/pact-foundation/pact-reference/ruby/ruby_ffi/pact/http-consumer-1-http-provider.json')
      result = PactFfi.pactffi_verifier_execute(verifier)
      puts PactFfi.pactffi_verifier_logs(verifier)
      expect(result).not_to be PactFfi::FfiVerifyProviderResponse['VERIFICATION_SUCCESSFUL']
    end
    it 'executes the pact verifier with no information and fails 3' do
      PactFfi.pactffi_verifier_set_filter_info(verifier, '', 'book', false)
      PactFfi.pactffi_verifier_set_provider_state(verifier, 'http://127.0.0.1:8000/change-state', true, true)
      PactFfi.pactffi_verifier_set_verification_options(verifier, false, 5000)
      PactFfi.pactffi_verifier_set_publish_options(verifier, '1.0.0', nil, nil, 0, 'some-branch')
      # ffi.pactffi_verifier_set_publish_options(handle, '1.0.0', nil,tags, tags.length, 'some-branch');
      PactFfi.pactffi_verifier_set_consumer_filters(verifier, nil, 0)
      # ffi.pactffi_verifier_set_consumer_filters(handle, getCData(consumers), count(consumers));
      local_pact = '/Users/saf/dev/pact-foundation/pact-reference/ruby/ruby_ffi/pact-ffi/pacts/http-consumer-1-http-provider.json'
      PactFfi.pactffi_verifier_add_file_source(verifier, local_pact)

      result = PactFfi.pactffi_verifier_execute(verifier)
      puts PactFfi.pactffi_verifier_logs(verifier)
      expect(result).not_to be PactFfi::FfiVerifyProviderResponse['VERIFICATION_SUCCESSFUL']
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
