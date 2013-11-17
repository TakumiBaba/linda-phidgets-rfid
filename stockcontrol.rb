#!/usr/bin/env ruby

require "rubygems"
require "eventmachine"
require "em-rocketio-linda-client"

EM::run do
  url = "http://linda.masuilab.org"
  space = "delta"
  linda = EM::RocketIO::Linda::Client.new url
  ts = linda.tuplespace[space]
  _ts = linda.tuplespace["stock"]

  linda.io.on "connect" do
    puts "connect"
    # _ts.write [{}]
    ts.watch ["rfid", "on"] do |tuple|
      tagid = tuple[2]
      _ts.take [] do |_tuple|
        puts tagid
        if _tuple[0].include? tagid
          _tuple[0][tagid]["stock"] = 0
        else
          _tuple[0][tagid] = {"name" => "", "stock" => 0}
        end
        _ts.write _tuple
      end
    end
  end  
end
