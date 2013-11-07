#!/usr/bin/env ruby
Bundler.require

EM::run do
  rfid = Phidgets::RFID.new
  linda = EM::RocketIO::Linda::Client.new "http://linda.masuilab.org"
  ts = linda.tuplespace["delta"]
  linda.io.on "connect" do
    rfid.on_tag do |device, id, obj|
      ts.write ["rfid", "on", id]
    end
    rfid.on_tag_lost do |device, id, obj|
      ts.write ["rfid", "off", id]
    end
  end
end