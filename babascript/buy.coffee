BabaScript = require "babascript"
Linda = require("node-linda-client")
linda = new Linda "linda.masuilab.org:10010", "delta"

linda.on "connect", ->
  console.log "connect"
  linda.ts.watch ["rfid", "on"], (result, info)->
    console.log result, info
    baba = new BabaScript()
    baba.牛乳買ってきて (d)->
      console.log d