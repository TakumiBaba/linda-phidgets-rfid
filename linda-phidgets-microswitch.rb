#!/usr/bin/env ruby
Bundler.require

# ifkit = Phidgets::InterfaceKit.new

Phidgets::InterfaceKit.new do |ifkit|
  ifkit.on_input_change do |device, input, state, obj|
    puts "Input #{input.index}'s state has changed to #{state}"
  end
  ifkit.on_sensor_change do |device, input, value, obj|
    puts "Sensor #{input.index}'s value has changed to #{value}"
  end
  EM::run do

  end
end