#! /usr/bin/env ruby

Bundler.require

ifkit = Phidgets::InterfaceKit.new
rfid  = Phidgets::RFID.new

rfid.on_attach do |device, obj|
  puts "rfid attached"
  device.anntena = true
  device.led = true
end

ifkit.on_attach do |device, obj|
  puts "ifkit attached"
end

sleep 5

EM::run do
  linda = EM::RocketIO::Linda::Client.new "http://linda.masuilab.org"
  ts = linda.tuplespace["orf"]
  linda.io.on "connect" do
    puts "connect"
    rfid.on_tag do |device, id, obj|
      puts "on"
      puts id
    end
    ifkit.on_input_change do |device, input, state, obj|
      puts "input #{state}"
    end
    ifkit.on_sensor_change do |device, input, value, obj| 
      puts "sensor #{value}"
    end
  end
end