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

# Sample gRPC server that implements the Calculator::AreaCalculator service.
#
# Usage: $ path/to/greeter_server.rb

this_dir = __dir__
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'area_calculator_services_pb'
require 'bigdecimal'

# AreaCalculatorServer is simple server that implements the AreaCalculator Calculator server.
class AreaCalculatorServer < AreaCalculator::Calculator::Service
  def calculate_one(calculate_req, _unused_call)
    puts "Calculating the area for one value  #{calculate_req}"
    area = shape_message(calculate_req)
    puts "Calculated #{area}"
    AreaCalculator::AreaResponse.new(value: [area])
  end

  def shape_message(message)
    case message.shape.to_s
    when 'rectangle'
      message.rectangle.length.to_f * message.rectangle.width.to_f
    when 'square'
      message.square.edge_length.to_f * message.square.edge_length.to_f
    when 'circle'
      Math::PI * message.circle.radius.to_f * message.circle.radius.to_f
    when 'parallelogram'
      message.parallelogram.base_length.to_f * mmessage.parallelogram.height.to_f
    when 'triangle'
      p = ((message.triangle.edge_a.to_f + message.triangle.edge_b.to_f + message.triangle.edge_c.to_f) / 2.0).to_f
      Math.sqrt((p * (p - message.triangle.edge_a.to_f) * (p - message.triangle.edge_b.to_f) * (p - message.triangle.edge_c.to_f)).to_f).to_f
    else
      raise "Error: not a valid shape (#{message})"
    end
  end
end

# main starts an RpcServer that receives requests to AreaCalculatorServer at the sample
# server port.
def main
  s = GRPC::RpcServer.new
  s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  s.handle(AreaCalculatorServer)
  # Runs the server with SIGHUP, SIGINT and SIGTERM signal handlers to
  #   gracefully shutdown.
  # User could also choose to run server via call to run_till_terminated
  s.run_till_terminated_or_interrupted([1, 'int', 'SIGTERM'])
end

main
