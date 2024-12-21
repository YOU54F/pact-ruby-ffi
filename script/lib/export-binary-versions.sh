#!/bin/bash -eu
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)" # Figure out where the script is running
PROJECT_DIR="${LIB_DIR}"/../../
export FFI_VERSION=v0.4.26
export STANDALONE_VERSION=2.4.20
export PLUGIN_CLI_VERSION=v0.1.3
export VERIFIER_CLI_VERSION=v1.1.4
# export STANDALONE_VERSION=$(grep "PACT_STANDALONE_VERSION = '" "$PROJECT_DIR"/standalone/install.ts | grep -E -o "'(.*)'" | cut -d"'" -f2)
# export FFI_VERSION=v$(grep "PACT_FFI_VERSION = '" "$PROJECT_DIR"/src/ffi/index.ts | grep -E -o "'(.*)'" | cut -d"'" -f2)