#!/bin/bash -eu

./script/download-libs.sh
mkdir -p logs
rake spec
ruby lib/detect_os.rb