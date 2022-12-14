# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: area_calculator.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("area_calculator.proto", :syntax => :proto3) do
    add_message "area_calculator.ShapeMessage" do
      oneof :shape do
        optional :square, :message, 1, "area_calculator.Square"
        optional :rectangle, :message, 2, "area_calculator.Rectangle"
        optional :circle, :message, 3, "area_calculator.Circle"
        optional :triangle, :message, 4, "area_calculator.Triangle"
        optional :parallelogram, :message, 5, "area_calculator.Parallelogram"
      end
    end
    add_message "area_calculator.Square" do
      optional :edge_length, :float, 1
    end
    add_message "area_calculator.Rectangle" do
      optional :length, :float, 1
      optional :width, :float, 2
    end
    add_message "area_calculator.Circle" do
      optional :radius, :float, 1
    end
    add_message "area_calculator.Triangle" do
      optional :edge_a, :float, 1
      optional :edge_b, :float, 2
      optional :edge_c, :float, 3
    end
    add_message "area_calculator.Parallelogram" do
      optional :base_length, :float, 1
      optional :height, :float, 2
    end
    add_message "area_calculator.AreaRequest" do
      repeated :shapes, :message, 1, "area_calculator.ShapeMessage"
    end
    add_message "area_calculator.AreaResponse" do
      repeated :value, :float, 1
    end
  end
end

module AreaCalculator
  ShapeMessage = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("area_calculator.ShapeMessage").msgclass
  Square = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("area_calculator.Square").msgclass
  Rectangle = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("area_calculator.Rectangle").msgclass
  Circle = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("area_calculator.Circle").msgclass
  Triangle = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("area_calculator.Triangle").msgclass
  Parallelogram = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("area_calculator.Parallelogram").msgclass
  AreaRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("area_calculator.AreaRequest").msgclass
  AreaResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("area_calculator.AreaResponse").msgclass
end
