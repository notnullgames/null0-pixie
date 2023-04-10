import boxy

let windowSize* = ivec2(320, 240)

proc null0_load*(bxy: Boxy) =
  # TODO: draw these as pixie arcs for no-assets
  bxy.addImage("ring1", readImage("assets/ring1.png"))
  bxy.addImage("ring2", readImage("assets/ring2.png"))
  bxy.addImage("ring3", readImage("assets/ring3.png"))

var frame: int
proc null0_update*(bxy: Boxy) =
  bxy.beginFrame(windowSize)
  let center = windowSize.vec2 / 2
  bxy.drawImage("ring1", center, angle = frame.float / 100)
  bxy.drawImage("ring2", center, angle = -frame.float / 190)
  bxy.drawImage("ring3", center, angle = frame.float / 170)

  bxy.endFrame()
  inc frame