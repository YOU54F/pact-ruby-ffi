#!/bin/bash -eu

./download-libs.sh
rake spec
ruby lib/detect_os.rb