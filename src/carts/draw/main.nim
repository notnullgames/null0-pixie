proc load*() {.null0.} =
  trace("Hello from draw.")
  load_image("ring1", "assets/ring1.png")
  load_image("ring2", "assets/ring2.png")
  load_image("ring3", "assets/ring3.png")

proc unload*() {.null0.} =
  trace("Ok, bye.")