SHELL := /bin/bash

ifeq '$(findstring ;,$(PATH))' ';'
	detected_OS := Windows
else
	detected_OS := $(shell uname 2>/dev/null || echo Unknown)
	detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
	detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
	detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
endif

install: 
	bundle install

download_libs: 
	./script/download-libs.sh

test: 
	rake spec

test_message_pact: 
	rspec spec/pactffi_create_message_pact_spec.rb

show_message_pact:
	cat pacts/message-consumer-2-message-provider.json | jq .  && \
	cat pacts/http-consumer-2-http-provider.json | jq . \

test_pactffi_create_mock_server_for_pact: 
	rspec spec/pactffi_create_mock_server_for_pact_spec.rb

show_pactffi_create_mock_server_for_pact:
	cat pacts/http-consumer-1-http-provider.json | jq .

test_pactffi_create_mock_server: 
	rspec spec/pactffi_create_mock_server_spec.rb

show_pactffi_create_mock_server:
	cat "pacts/Consumer-Alice Service.json" | jq .

install_protobuf_plugin:
	pact/plugin/pact-plugin-cli -y install https://github.com/pactflow/pact-protobuf-plugin/releases/latest

install_demo_grpc:
	cd examples/area_calculator && bundle install

test_demo_gprc_pact:
	rspec examples/area_calculator/spec/pactffi_create_plugin_pact_spec.rb

show_demo_gprc_pact:
	cat pacts/grpc-consumer-ruby-area-calculator-provider.json | jq .

start_demo_gprc_provider:
	ruby examples/area_calculator/area_calculator_provider.rb

start_demo_gprc_consumer:
	ruby examples/area_calculator/area_calculator_consumer_run.rb

verify_demo_gprc_local:
	TEST_COMMAND='pact/verifier/pact_verifier_cli -f pacts/grpc-consumer-ruby-area-calculator-provider.json -p 37757 -l info' \
	make start_server_and_test

start_broker:
	docker-compose up -d
	
wait_for_broker:
	curl -Lso - https://raw.githubusercontent.com/eficode/wait-for/v2.2.3/wait-for | sh -s -- http://localhost:8000 --timeout 120 -- echo "success"

stop_broker:
	docker-compose down

publish_pacts:
	case "${detected_OS}" in \
	"WINDOWS"|"MINGW"|"MSYS")pact/standalone/pact/bin/pact-broker.bat publish pacts --consumer-app-version $(shell git rev-parse HEAD)"${detected_OS}" --branch $(shell git rev-parse --abbrev-ref HEAD);; \
	*) pact/standalone/pact/bin/pact-broker publish pacts --consumer-app-version $(shell git rev-parse HEAD)${detected_OS} --branch $(shell git rev-parse --abbrev-ref HEAD);; \
	esac
	

verify_demo_gprc_publish_broker:
	TEST_COMMAND="pact/verifier/pact_verifier_cli \
	-f pacts/grpc-consumer-ruby-area-calculator-provider.json \
	-p 37757 \
	-l info \
	--publish \
	--provider-name area-calculator-provider \
	--provider-version $(shell git rev-parse HEAD)${detected_OS} \
	--provider-branch $(shell git rev-parse --abbrev-ref HEAD)" \
	./start_server_and_test.sh

verify_demo_gprc_fetch_broker:
	TEST_COMMAND="pact/verifier/pact_verifier_cli \
	-p 37757 \
	-l debug \
	--publish \
	--provider-name area-calculator-provider \
	--provider-version $(shell git rev-parse HEAD)${detected_OS} \
	--provider-branch $(shell git rev-parse --abbrev-ref HEAD) \
	--consumer-version-selectors {\"matchingBranch\":true}" \
	 ./start_server_and_test.sh


start_server_and_test:
	./start_server_and_test.sh