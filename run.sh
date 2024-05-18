#!/bin/bash -eu

./script/download-all-libs.sh
bundle install
rake spec
# rspec examples/area_calculator/spec/pactffi_create_plugin_pact_spec.rb