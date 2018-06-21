ruleset track_trips {
  meta {
    shares __testing
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      //, { "name": "entry", "args": [ "key" ] }
      ] , "events":[
      { "domain": "echo", "type": "message", "attrs": [ "mileage"] }
      ]
    }
  }

  rule process_trip {
  select when echo message
  pre{
    mileage = event:attr("mileage").klog("Your mileage: ")
  }
  send_directive("trip", {"length": mileage})
}
}
