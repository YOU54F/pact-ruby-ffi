#!/bin/bash -eu

./script/download-libs.sh
rake spec
# rspec examples/area_calculator/spec/pactffi_create_plugin_pact_spec.rb