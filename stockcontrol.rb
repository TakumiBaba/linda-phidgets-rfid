#!/usr/bin/env ruby

require "rubygems"
require "eventmachine"
require "em-rocketio-linda-client"

tagids = {
  "01068e2978" => "milk",
  "01068e2533" => "deka basami",
  "01068e2c90" => "spoon",
  "01068e065a" => "mini clip"
}

items = ["milk", "hasami", "spoon", "clip", "mikan", "beer"]

EM::run do
  url = "http://linda.masuilab.org"
  space = "orf"
  linda = EM::RocketIO::Linda::Client.new url
  ts = linda.tuplespace[space]
  _ts = linda.tuplespace["stock"]

  linda.io.on "connect" do
    puts "connect"
    # _ts.list [] do |results|
    #   i = 0
    #   for r in results
    #     _ts.take [] do |tuple|
    #       puts "take"
    #       _ts.write [items[i], 10]
    #       i = i+1
    #       puts "write"
    #       puts tuple
    #     end
    #   end
    # end
    ts.watch ["rfid", "on"] do |tuple|
      _ts.list [] do |tuples|
        flag = false
        for t in tuples
          puts t
          puts "t[2] is #{t[2]}, tuple[2] is #{tuple[2]}"
          puts t[0].class, tuple[2].class
          if t[0] == tuple[2]
            puts "FLAG!!"
            flag = true
          end
        end
        puts "flag is #{flag}"
        if !flag
          _ts.write [tuple[2]]
        end
      end
    end

    ts.watch ["press", "off"] do |tuple|
      _ts.list [] do |tuples|
        flag = false
        for t in tuples
          puts t[0]
          if t[0] == "mikan"
            puts "flag"
            flag = true
          end
        end
        if !flag
          _ts.write ["mikan"]
        end
      end
    end

    ts.watch ["switch", "off"] do |tuple|
      puts "switch"
      _ts.list [] do |tuples|
        flag = false
        for t in tuples
          if t[0] == "beer"
            flag = true
          end
        end
        if !flag
          _ts.write ["beer"]
        end
      end
    end

    ts.watch ["list"] do |tuple|
      puts "list items"
      _ts.list [] do |results|
        puts results
      end
    end
  end  
end
