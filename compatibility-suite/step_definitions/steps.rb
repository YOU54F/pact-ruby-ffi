require 'pact/ffi'
require 'pact/ffi/logger'
require 'pact/ffi/mock_server'
require 'pact/ffi/http_consumer'
require 'pact/ffi/utils'
require 'pact/ffi/message_consumer'
require 'pact/ffi/sync_message_consumer'
require 'pact/ffi/async_message_pact'
require 'pact/ffi/verifier'
require 'rackup'
require 'nokogiri'
require 'sucker_punch'
PactFfi.log_to_stdout(3)
Given('an HTTP interaction is being defined for a consumer test') do
  @pact = PactFfi::HttpConsumer.new_pact('a', 'b') if @pact.nil?
  @interaction = PactFfi::HttpConsumer.new_interaction(@pact, 'interaction for a consumer test')
  PactFfi::HttpConsumer.with_specification(@pact, PactFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V4'])
  @pact_file_path = './pacts/a-b.json'
end

When('the Pact file for the test is generated') do
  @mock_server_port = PactFfi::MockServer.create_for_transport(@pact, '127.0.0.1', 0, 'http', nil)
  res_write_pact = PactFfi::MockServer.write_pact_file(@mock_server_port, './pacts', true)
  # puts res_write_pact
  PactFfi.cleanup_mock_server(@mock_server_port)
end

Then('the first interaction in the Pact file will have a type of {string}') do |string|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  # puts pact_json['interactions'][0]['type']
  expect(pact_json['interactions'][0]['type']).to eq string
end

Given('a key of {string} is specified for the HTTP interaction') do |string|
  res = PactFfi::Utils.set_key(@interaction, string)
  # puts 'write key res'
  # puts res
end

Then('the first interaction in the Pact file will have {string} = {string}') do |string, string2|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  # puts pact_json['interactions'][0]
  expect(pact_json['interactions'][0][string]).to eq JSON.load(string2)
end

Given('the HTTP interaction is marked as pending') do
  res = PactFfi::Utils.set_pending(@interaction, true)
  # puts 'set_pending res'
  # puts res
end

Given('a comment {string} is added to the HTTP interaction') do |string|
  res = PactFfi::Utils.add_text_comment(@interaction, string)
  # puts 'set_pending res'
  # puts res
end

Given('a request configured with the following generators:') do |_table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Given('the generator test mode is set as {string}') do |_string|
  pending # Write code here that turns the phrase above into concrete actions
end

When('the request is prepared for use with a {string} context:') do |_string, _table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the body value for {string} will have been replaced with {string}') do |_string, _string2|
  pending # Write code here that turns the phrase above into concrete actions
end

When('the request is prepared for use') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the body value for {string} will have been replaced with a {string}') do |_string, _string2|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('the following HTTP interactions have been defined:') do |_table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Given('a provider is started that returns the response from interaction {int}, with the following changes:') do |_int, _table|
  # Given('a provider is started that returns the response from interaction {float}, with the following changes:') do |float, table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Given('a Pact file for interaction {int} is to be verified, but is marked pending') do |_int|
  # Given('a Pact file for interaction {float} is to be verified, but is marked pending') do |float|
  pending # Write code here that turns the phrase above into concrete actions
end

When('the verification is run') do
  print 'veri started'
  @verifier = PactFfi::Verifier.new_for_application('pact-ruby', '0.0.0')
  PactFfi::Verifier.set_provider_info(@verifier, 'b', nil, nil, 8080, nil)
  PactFfi::Verifier.add_provider_transport(@verifier, 'message', 8080, '/__messages', 'http')
  PactFfi::Verifier.add_file_source(@verifier, @pact_file_path)
  PactFfi::Verifier.execute(@verifier)
  puts 'veri ended'
end

Then('the verification will be successful') do
  expect(JSON.load(PactFfi::Verifier.json(@verifier))['result']).to be true
end

Then('there will be a pending {string} error') do |error_message|
  error_message = 'BodyMismatch' if error_message == 'Body had differences'
  expect(JSON.load(PactFfi::Verifier.json(@verifier))['pendingErrors'].to_s).to include(error_message)
end

Given('a provider is started that returns the response from interaction {int}') do |_int|
  # Given('a provider is started that returns the response from interaction {float}') do |float|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('a Pact file for interaction {int} is to be verified with the following comments:') do |_int, _table|
  # Given('a Pact file for interaction {float} is to be verified with the following comments:') do |float, table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the comment {string} will have been printed to the console') do |comment|
  expect(JSON.load(PactFfi::Verifier.json(@verifier))['output']).to include(comment)
end

Then('the {string} will displayed as the original test name') do |test_name|
  expect(JSON.load(PactFfi::Verifier.json(@verifier))['output'].to_s).to include("Test Name: #{test_name}")
end

Given('an expected response configured with the following:') do |_table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Given('a status {int} response is received') do |_int|
  # Given('a status {float} response is received') do |float|
  pending # Write code here that turns the phrase above into concrete actions
end

When('the response is compared to the expected one') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the response comparison should be OK') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the response comparison should NOT be OK') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the response mismatches will contain a {string} mismatch with error {string}') do |_string, _string2|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('an expected request configured with the following:') do |_table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Given('a request is received with the following:') do |_table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

When('the request is compared to the expected one') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the comparison should be OK') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the comparison should NOT be OK') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the mismatches will contain a mismatch with error {string} -> {string}') do |_string, _string2|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the mismatches will contain a mismatch with error {string} {float}> {string}') do |_string, _float, _string2|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('a message interaction is being defined for a consumer test') do
  @pact = PactFfi::MessageConsumer.new_message_pact('a', 'b') if @pact.nil?
  @interaction = PactFfi::MessageConsumer.new_message_interaction(@pact, 'interaction for a message-consumer test')
  PactFfi::HttpConsumer.with_specification(@pact, PactFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V4'])
  @pact_file_path = './pacts/a-b.json'
end

Given('a key of {string} is specified for the message interaction') do |string|
  PactFfi::Utils.set_key(@interaction, string)
end

Given('the message interaction is marked as pending') do
  PactFfi::Utils.set_pending(@interaction, true)
end

Given('a comment {string} is added to the message interaction') do |string|
  PactFfi::Utils.add_text_comment(@interaction, string)
end

Given('a provider is started that can generate the {string} message with {string}') do |_filetype, file|
  filename = file.split(':').last.strip.split('.').first if file.include?('file:')

  @pid = Process.spawn("ruby compatibility-suite/support/test_servers/#{filename}-server.rb")
  puts @pid
end

After do
  Process.kill('SIGKILL', @pid) if @pid
  Process.wait(@pid) if @pid
end

Given('a Pact file for {string}:{string} is to be verified, but is marked pending') do |_filetype, file|
  @pact = PactFfi::MessageConsumer.new_message_pact('a', 'b') if @pact.nil?
  @interaction = PactFfi::AsyncMessageConsumer.new(@pact,
                                                   'interaction for a message-consumer verification')
  PactFfi::HttpConsumer.with_specification(@pact, PactFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V4'])
  @pact_file_path = './pacts/a-b.json'
  PactFfi::Utils.set_pending(@interaction, true)
  if file.include?('file:')
    filename = file.split(':').last.strip
    fixture = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{filename}")
  end
  PactFfi.with_body(@interaction, 0, 'application/json', fixture)
  PactFfi::MessageConsumer.write_message_pact_file(@pact, './pacts', true)
end

Given('a Pact file for {string}:{string} is to be verified with the following comments:') do |_filetype, file, comments|
  @pact = PactFfi::MessageConsumer.new_message_pact('a', 'b') if @pact.nil?
  @interaction = PactFfi::AsyncMessageConsumer.new(@pact,
                                                   'interaction for a message-consumer verification')
  PactFfi::HttpConsumer.with_specification(@pact, PactFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V4'])
  @pact_file_path = './pacts/a-b.json'
  comments.hashes.each do |entries|
    comment = entries[:comment]
    type = entries[:type]
    if type == 'text'
      PactFfi::Utils.add_text_comment(@interaction, comment)
    elsif type == 'testname'
      PactFfi.interaction_test_name(@interaction, comment)
    end
  end
  if file.include?('file:')
    filename = file.split(':').last.strip
    fixture = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{filename}")
  end
  PactFfi.with_body(@interaction, 0, 'application/json', fixture)
  PactFfi::MessageConsumer.write_message_pact_file(@pact, './pacts', true)
end

Given('a synchronous message interaction is being defined for a consumer test') do
  @pact = PactFfi::MessageConsumer.new_message_pact('a', 'b') if @pact.nil?
  @interaction = PactFfi::SyncMessageConsumer.new_interaction(@pact, 'interaction for a sync-message-consumer test')
  PactFfi::HttpConsumer.with_specification(@pact, PactFfi::FfiSpecificationVersion['SPECIFICATION_VERSION_V4'])
  @pact_file_path = './pacts/a-b.json'
end

Given('a key of {string} is specified for the synchronous message interaction') do |string|
  PactFfi::Utils.set_key(@interaction, string)
end

Given('the synchronous message interaction is marked as pending') do
  PactFfi::Utils.set_pending(@interaction, true)
end

Given('a comment {string} is added to the synchronous message interaction') do |string|
  PactFfi::Utils.add_text_comment(@interaction, string)
end

Given('the message request payload contains the {string} JSON document') do |string|
  fixture = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{string}.json")
  PactFfi.with_body(@interaction, 0, 'application/json', fixture)
end

Given('the message response payload contains the {string} document') do |filename|
  if filename.include?('file')
    filename = filename.split(':').last.strip
    fileext = File.extname(filename).delete_prefix('.')
    content_type = "application/#{fileext}"
    # puts filename
    # puts content_type
  else
    content_type = 'application/json'
  end
  fixture = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{filename}")
  if fileext.include?('xml')
    doc = Nokogiri::XML(fixture)
    content_type = doc.xpath('//contentType').text
    contents = Nokogiri::XML(doc.xpath('//contents').text)
    fixture = contents.to_xml

    # fixture = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<values>\n  <one>A</one>\n  <two>B</two>\n</values>\n"

    # we can also use integration json format
    # fixture = '{"root":{"name":"values","children":[{"name":"one","children":[{"content":"A"}]},{"name":"two","children":[{"content":"B"}]}]}}'
  end

  res = PactFfi.with_body(@interaction, 1, content_type, fixture)
  # puts "result of with_body: #{res}"
end

When('the message is successfully processed') do
  PactFfi::MessageConsumer.write_message_pact_file(@pact, './pacts', true)
end

Then('the received message payload will contain the {string} document') do |_filename|
  puts 'todo'
end

Then('the received message content type will be {string}') do |_expected_content_type|
  puts 'todo'
end

Then('the consumer test will have passed') do
  puts 'todo'
  # pending # Write code here that turns the phrase above into concrete actions
end

Then('a Pact file for the message interaction will have been written') do
  PactFfi::MessageConsumer.write_message_pact_file(@pact, './pacts', true)
end

Then('the pact file will contain {int} interaction') do |int|
  # Then('the pact file will contain {float} interaction') do |float|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  interaction_length = pact_json['interactions'].length
  expect(interaction_length).to eq int
end

Then('the first interaction in the pact file will contain the {string} document as the request') do |filename|
  if filename.include?('file')
    filename = filename.split(':').last.strip
    fileext = File.extname(filename).delete_prefix('.')
    expected_contents = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{filename}")
  end
  if fileext.include?('xml')
    doc = Nokogiri::XML(fixture)
    expected_content_type = doc.xpath('//contentType').text
    expected_contents = Nokogiri::XML(doc.xpath('//contents').text).to_xml
  else
    fileext.include?('json')
    expected_contents = JSON.load(expected_contents)
  end

  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  contents = pact_json['interactions'][0]['request']['contents']
  content = contents['content']
  expect(content).to eq expected_contents
end

Then('the first interaction in the pact file request content type will be {string}') do |expected_content_type|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  contents = pact_json['interactions'][0]['request']['contents']
  content_type = contents['contentType']
  expect(content_type).to eq expected_content_type
end

Then('the first interaction in the pact file will contain the {string} document as a response') do |filename|
  if filename.include?('file')
    filename = filename.split(':').last.strip
    fileext = File.extname(filename).delete_prefix('.')
    expected_content_type = "application/#{fileext}"
    expected_contents = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{filename}")
  else
    expected_content_type = 'application/json'
  end
  if fileext.include?('xml')
    doc = Nokogiri::XML(expected_contents)
    expected_content_type = doc.xpath('//contentType').text
    expected_contents = Nokogiri::XML(doc.xpath('//contents').text).to_xml
  end

  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  contents = pact_json['interactions'][0]['response'][0]['contents']
  content = contents['content']
  content_type = contents['contentType']
  expect(content_type).to eq expected_content_type
  expect(content).to eq expected_contents
end

Then('the first interaction in the pact file response content type will be {string}') do |expected_content_type|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  contents = pact_json['interactions'][0]['response'][0]['contents']
  content_type = contents['contentType']
  expect(content_type).to eq expected_content_type
end

Then('the first interaction in the pact file will contain {int} response messages') do |int|
  # Then('the first interaction in the pact file will contain {float} response messages') do |float|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  response_message_length = pact_json['interactions'][0]['response'].length
  expect(response_message_length).to eq int
end

Then('the first interaction in the pact file will contain the {string} document as the first response message') do |filename|
  if filename.include?('file')
    filename = filename.split(':').last.strip
    fileext = File.extname(filename).delete_prefix('.')
    expected_content_type = "application/#{fileext}"
    expected_contents = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{filename}")
  else
    expected_content_type = 'application/json'
  end
  if fileext.include?('xml')
    doc = Nokogiri::XML(expected_contents)
    expected_content_type = doc.xpath('//contentType').text
    expected_contents = Nokogiri::XML(doc.xpath('//contents').text).to_xml
  else
    fileext.include?('json')
    expected_contents = JSON.load(expected_contents)
  end

  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  contents = pact_json['interactions'][0]['response'][0]['contents']
  content = contents['content']
  content_type = contents['contentType']
  expect(content_type).to eq expected_content_type
  expect(content).to eq expected_contents
end

Then('the first interaction in the pact file will contain the {string} document as the second response message') do |filename|
  if filename.include?('file')
    filename = filename.split(':').last.strip
    fileext = File.extname(filename).delete_prefix('.')
    expected_content_type = "application/#{fileext}"
    expected_contents = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{filename}")
  else
    expected_content_type = 'application/json'
  end
  if fileext.include?('xml')
    doc = Nokogiri::XML(expected_contents)
    expected_content_type = doc.xpath('//contentType').text
    expected_contents = Nokogiri::XML(doc.xpath('//contents').text).to_xml
  else
    fileext.include?('json')
    expected_contents = JSON.load(expected_contents)
  end

  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  contents = pact_json['interactions'][0]['response'][1]['contents']
  content = contents['content']
  content_type = contents['contentType']
  expect(content_type).to eq expected_content_type
  expect(content).to eq expected_contents
end

Given('the message request contains the following metadata:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  table.hashes.each do |entries|
    key = entries[:key]
    value = entries[:value]
    value = value.split('JSON: ').last.strip if value.include?('JSON: ')

    PactFfi.with_metadata(@interaction, key, value, 0)
  end
end

Then('the received message request metadata will contain {string} == {string}') do |key, value|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  metadata = pact_json['interactions'][0]['request']['metadata']
  value = JSON.load(value.split('JSON: ').last.strip) if value.include?('JSON: ')
  expect(metadata[key]).to eq value
end

Then('the first message in the pact file will contain the request message metadata {string} == {string}') do |key, value|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  metadata = pact_json['interactions'][0]['request']['metadata']
  value = JSON.load(value.split('JSON: ').last.strip) if value.include?('JSON: ')
  expect(metadata[key]).to eq value
end

Given('a provider state {string} for the synchronous message is specified') do |state|
  PactFfi.given(@interaction, state)
end

Then('the first message in the pact file will contain {int} provider states') do |_int|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  provider_states = pact_json['interactions'][0]['providerStates']
  expect(provider_states.length).to eq _int
end

Then('the first message in the Pact file will contain provider state {string}') do |state|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  provider_states = pact_json['interactions'][0]['providerStates']
  expect(provider_states.any? { |ps| ps['name'] == state }).to be true
end

Given('a provider state {string} for the synchronous message is specified with the following data:') do |description, params_table|
  # table is a Cucumber::MultilineArgument::DataTable
  params = params_table.hashes.first.transform_values do |value|
    if value.match?(/\A[-+]?\d+\z/)
      value.to_i
    elsif value.match?(/\A[-+]?\d+\.\d+\z/)
      value.to_f
    else
      value.gsub('"', '')
    end
  end
  PactFfi.given_with_params(@interaction, description, params.to_json)
end

Then('the first message in the pact file will contain {int} provider state') do |expected_provider_states_length|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  provider_states = pact_json['interactions'][0]['providerStates']
  expect(provider_states.length).to eq expected_provider_states_length
end

Then('the provider state {string} for the message will contain the following parameters:') do |expected_provider_state_name, expected_params_table|
  # expected_params_table is a Cucumber::MultilineArgument::DataTable
  expected_params_hash = JSON.load(expected_params_table.hashes.first['parameters'])
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  provider_states = pact_json['interactions'][0]['providerStates']
  provider_state_name = provider_states[0]['name']
  params = provider_states[0]['params']
  expect(provider_state_name).to eq expected_provider_state_name
  expect(params).to eq expected_params_hash
end

Given('the message request is configured with the following:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  required_body = {}
  required_generators = {}
  required_metadata = {}
  table.hashes.each do |entries|
    required_metadata = entries[:metadata]
    required_body = entries[:body]
    required_generators = entries[:generators]
  end
  # puts required_body
  # puts required_generators
  # puts required_metadata

  if required_body&.include?('file')
    filename = required_body.split(':').last.strip
    body = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{filename}")
  end
  # puts body
  if required_generators&.include?('.json')
    generators = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{required_generators}")
  else
    required_generators&.include?('JSON: ')
    generators = required_generators.split('JSON: ').last.strip
  end

  PactFfi.with_body(@interaction, 0, 'application/json', body) if body
  PactFfi.with_generators(@interaction, 0, generators) if generators

  if required_metadata
    JSON.load(required_metadata).each do |key, value|
      PactFfi.with_metadata(@interaction, key, value.to_s, 0)
    end
  end
end

Given('the message response is configured with the following:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  required_body = {}
  required_generators = {}
  required_metadata = {}
  table.hashes.each do |entries|
    required_metadata = entries[:metadata]
    required_body = entries[:body]
    required_generators = entries[:generators]
  end

  if required_body&.include?('file')
    filename = required_body.split(':').last.strip
    body = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{filename}")
  else
    body = '{}'
  end
  if required_generators&.include?('.json')
    generators = File.read("compatibility-suite/pact-compatibility-suite/fixtures/#{required_generators}")
  else
    required_generators&.include?('JSON: ')
    generators = required_generators.split('JSON: ').last.strip
  end

  PactFfi.with_body(@interaction, 1, 'application/json', body) if body
  PactFfi.with_generators(@interaction, 1, generators) if generators

  if required_metadata
    JSON.load(required_metadata).each do |key, value|
      PactFfi.with_metadata(@interaction, key, value.to_s, 1)
    end
  end
end

Then('the message request contents for {string} will have been replaced with an {string}') do |key, value|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  metadata = pact_json['interactions'][0]['request']['generators']['body']
  if value == 'integer'
    expect(metadata[key]['type']).to eq 'RandomInt'
  else
    expect(metadata[key]['type']).to eq value
  end
end

Then('the message response contents for {string} will have been replaced with an {string}') do |key, value|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  metadata = pact_json['interactions'][0]['response'][0]['generators']['body']
  if value == 'integer'
    expect(metadata[key]['type']).to eq 'RandomInt'
  else
    expect(metadata[key]['type']).to eq value
  end
end

Then('the received message request metadata will contain {string} replaced with an {string}') do |key, value|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  metadata = pact_json['interactions'][0]['request']['generators']['metadata']
  if value == 'integer'
    expect(metadata[key]['type']).to eq 'RandomInt' if value == 'integer'
  else
    expect(metadata[key]['type']).to eq value
  end
end

Then('the received message response metadata will contain {string} == {string}') do |key, value|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  metadata = pact_json['interactions'][0]['response'][0]['metadata']
  value = JSON.load(value.split(':').last.strip) if value.include?('JSON: ')
  expect(metadata[key]).to eq value
end

Then('the received message response metadata will contain {string} replaced with an {string}') do |key, value|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  metadata = pact_json['interactions'][0]['response'][0]['generators']['metadata']
  value = JSON.load(value.split(':').last.strip) if value.include?('JSON: ')
  if value == 'integer'
    expect(metadata[key]['type']).to eq 'RandomInt'
  else
    expect(metadata[key]['type']).to eq value
  end
end

Then('there will be an interaction in the Pact file with a type of {string}') do |type|
  pact_file_content = File.read(@pact_file_path)
  pact_json = JSON.parse(pact_file_content)
  interactions = pact_json['interactions']
  puts pact_json
  expect(interactions.any? { |ps| ps['type'] == type }).to be true
end
