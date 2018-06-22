ruleset track_trips {
  meta {
    shares __testing
  }
  global {
    long_trip = 100
    __testing = { "queries":
      [ { "name": "__testing" }
      //, { "name": "entry", "args": [ "key" ] }
      ] , "events":[
      { "domain": "car", "type": "new", "attrs": [ "mileage"] },
       {"domain": "explicit", "type": "trip_processed", "attrs": [ "mileage"] }
      ]
    }
  }
  rule  process_trip {
  select when car new
  fired {
    raise explicit event "trip_processed" attributes event:attrs
  }
}
  rule  trip_processed {
  select when explicit trip_processed
  pre{
    mileage = event:attr("mileage").klog("Your mileage: ")
  }
  send_directive("trip", {"length": mileage})
}
  rule  find_long_trips {
  select when explicit trip_processed
  pre{
    mileage = event:attr("mileage").as("Number").klog("Your mileage: ")
  }
  fired {
    raise explicit event "found_long_trip" attributes event:attrs if (mileage>long_trip)
  }
}
  rule  found_long_trip {
  select when explicit found_long_trip
  pre{
    mileage = event:attr("mileage").klog("Your mileage: ")
  }
  send_directive("trip", {"something": "long trip found!"})
}
}

