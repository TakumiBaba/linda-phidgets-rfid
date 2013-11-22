#!/usr/bin/env ruby

require "rubygems"
require "eventmachine"
require "em-rocketio-linda-client"

rfid = Phidgets::RFID.new
rfid.on_attach do |device, obj|
  puts "#{device.device_class} attached"
  device.antenna = true
  device.led = true
  sleep 1
end

tagids = {
  "01068e2978" => "milk",
  "01068e2533" => "deka basami",
  "01068e2c90" => "spoon",
  "01068e065a" => "mini clip"
}

EM::run do
  
  linda = EM::RocketIO::Linda::Client.new "http://linda.shokai.org"
  ts = linda.tuplespace["orf"]
  linda.io.on "connect" do
    puts "connect"
    rfid.on_tag do |device, id, obj|
      puts "on"
      ts.write ["rfid", "on", tagids[id]]
    end
  end
end
