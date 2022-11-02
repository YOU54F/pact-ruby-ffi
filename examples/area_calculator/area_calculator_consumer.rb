#!/usr/bin/env ruby

# Copyright 2015 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Sample app that connects to a Greeter service.
#
# Usage: $ path/to/greeter_client.rb

this_dir = __dir__
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'area_calculator_services_pb'
require 'json'
def main
  # user = ARGV.size > 0 ?  ARGV[0] : 'world'
  # hostname = ARGV.size > 1 ?  ARGV[1] : 'localhost:50051'
  hostname = 'localhost:50051'
  stub = AreaCalculator::Calculator::Stub.new(hostname, :this_channel_is_insecure)
  begin
    message = stub.calculate_one(AreaCalculator::ShapeMessage.new({
                                                                   "triangle": {
                                                                     "edge_a": 10,
                                                                     "edge_b": 10,
                                                                     "edge_c": 10,
                                                                   }
                                                                  })).value
    # message = stub.calculate_one(AreaCalculator::ShapeMessage.new({
    #                                                                "rectangle": {
    #                                                                  "length": 3,
    #                                                                  "width": 3
    #                                                                }
    #                                                               })).value
    p "Area: #{message}"
  rescue GRPC::BadStatus => e
    abort "ERROR: #{e.message}"
  end
end

main
