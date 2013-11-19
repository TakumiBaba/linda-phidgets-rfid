#!/usr/bin/env ruby
Bundler.require

ifkit = Phidgets::InterfaceKit.new

ifkit.on_attach do |device, obj|
  sleep 1
end

sleep 5

EM::run do
  linda = EM::RocketIO::Linda::Client.new "http://linda.masuilab.org"
  ts = linda.tuplespace["orf"]
  linda.io.on "connect" do
    ifkit.on_input_change do |device, input, state, obj|
      puts "Input #{input.index}'s state has changed to #{state}"
    end
    ifkit.on_sensor_change do |device, input, value, obj|
      puts "Sensor #{input.index}'s value has changed to #{value}"
    end
  end
end
