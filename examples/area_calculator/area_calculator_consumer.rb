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

module AreaCalculatorConsumer
  def self.get_triangle_area(address)
    # Set up a connection to the server.
    stub = AreaCalculator::Calculator::Stub.new(address, :this_channel_is_insecure)
    begin
      triangle = {
        "triangle": {
          "edge_a": 10,
          "edge_b": 10,
          "edge_c": 10
        }
      }
      p 'Sending calculate triangle area request'
      message = stub.calculate_one(AreaCalculator::ShapeMessage.new(triangle)).value
      p "Area: #{message[0]}"
      message[0]
    end
  end

  def self.get_rectangle_area(address)
    # Set up a connection to the server.
    stub = AreaCalculator::Calculator::Stub.new(address, :this_channel_is_insecure)
    begin
      rectangle = {
        "rectangle": {
          "length": 3,
          "width": 4
        }
      }
      p 'Sending calculate rectangle area request'
      message = stub.calculate_one(AreaCalculator::ShapeMessage.new(rectangle)).value
      p "Area: #{message[0]}"
      message
    end
  end

  def self.main
    hostname = 'localhost:37757'
    get_triangle_area(hostname)
  rescue GRPC::BadStatus => e
    abort "ERROR: #{e.message}"
  end
end
