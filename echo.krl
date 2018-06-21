ruleset echo {
  meta {
    shares __testing
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      //, { "name": "entry", "args": [ "key" ] }
      ] , "events":
      [{ "domain": "echo", "type": "hello" }
      , { "domain": "echo", "type": "message", "attrs": [ "message"] }
      ]
    }
  }
  rule hello_world {
  select when echo hello
  send_directive("say", {"something":"Hello world"})
}
  rule message {
  select when echo message
  pre{
    message = event:attr("message").klog("Your message: ")
  }
  send_directive("say", {"something":message})
}
}
