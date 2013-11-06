#!/usr/bin/env ruby
require "rubygems"
require "phidgets-ffi"
require "eventmachine"
require "em-rocketio-linda-client"

EM::run do
  rfid = Phidgets::RFID.new

  rfid.on_attach do |device, obj|
    device.antenna = true
    device.led = true
    sleep 1
  end

  url = "http://linda.masuilab.org"
  space = "delta"

  linda = EM::RocketIO::Linda::Client.new url
  ts = linda.tuplespace[space]

  linda.io.on "connect" do
    rfid.on_tag do |device, tag, obj|
      puts "tag is #{tag}"
      ts.write ["rfid", "on", tag]
    end
    rfid.on_tag_lost do |device, tag, obj|
      puts "tag lost #{tag}"
      ts.write ["rfid", "off", tag]
    end
  end
end