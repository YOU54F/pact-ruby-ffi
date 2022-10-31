require 'ffi'
require 'json'
require 'httparty'
require_relative 'PactFFILib.rb'
include PactFFILib



puts 'Pact FFI version:'
puts PactFFILib.pactffi_version
ffi = PactFFILib


ffi.pactffi_init('LOG_LEVEL');

tags = ['feature-x', 'master', 'test', 'prod'];
consumers = ['http-consumer-1', 'http-consumer-2', 'message-consumer-2'];

# function getCData(array items): FFI\CData
# {
#     itemsSize = count(items);
#     cDataItems  = FFI::new("char*[{itemsSize}]");
#     foreach (items as index => item) {
#         length = \strlen(item);
#         itemSize   = length + 1;
#         cDataItem  = FFI::new("char[{itemSize}]", false);
#         FFI::memcpy(cDataItem, item, length);
#         cDataItems[index] = cDataItem;
#     }

#     return cDataItems;
# }

# length = contents.length
# size = length + 1
# memBuf = FFI::MemoryPointer.new(:uint, length) 
# memBuf.put_bytes(0, contents)

# handle = ffi.pactffi_verifier_new(); - need to add ffi func
handle = ffi.pactffi_verifier_new_for_application('pact-ruby','1.0.0')
ffi.pactffi_verifier_set_provider_info(handle, 'http-provider', 'http', 'localhost', 8000, '/');
ffi.pactffi_verifier_set_filter_info(handle, '', 'book', false);
ffi.pactffi_verifier_set_provider_state(handle, 'http://localhost:8000/change-state', true, true);
ffi.pactffi_verifier_set_verification_options(handle, false, 5000);
ffi.pactffi_verifier_set_publish_options(handle, '1.0.0', nil,nil, 0, 'some-branch');
# ffi.pactffi_verifier_set_publish_options(handle, '1.0.0', nil,tags, tags.length, 'some-branch');
ffi.pactffi_verifier_set_consumer_filters(handle, nil, 0);
# ffi.pactffi_verifier_set_consumer_filters(handle, getCData(consumers), count(consumers));

# ffi.pactffi_verifier_add_file_source(handle,'/Users/saf/dev/pact-foundation/pact-reference/ruby/ruby_ffi/pact/http-consumer-1-http-provider.json')
ffi.pactffi_verifier_add_directory_source(handle, '/Users/saf/dev/pact-foundation/pact-reference/ruby/ruby_ffi/pact/');
result = ffi.pactffi_verifier_execute(handle);

time = Time.now
sleep 5 and puts 'waiting for reqs' until Time.now > time + 1 || result == 0


if !result == 0
  puts "We are winning!\n"
  puts result
  puts ffi.pactffi_verifier_logs(handle)
  ffi.pactffi_verifier_shutdown(handle)
  exit!
else
  puts "We got some problems, Boo!\n"
  puts result
  puts ffi.pactffi_verifier_logs(handle)
  ffi.pactffi_verifier_shutdown(handle)
  exit
end