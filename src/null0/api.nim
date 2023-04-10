import boxy

let windowSize* = ivec2(320, 240)

var current_boxy: Boxy


proc null0_load*(bxy: Boxy) =
  current_boxy = bxy

  # TODO: draw these as pixie arcs for no-assets
  current_boxy.addImage("ring1", readImage("assets/ring1.png"))
  current_boxy.addImage("ring2", readImage("assets/ring2.png"))
  current_boxy.addImage("ring3", readImage("assets/ring3.png"))

var frame: int
proc null0_update*() =
  current_boxy.beginFrame(windowSize)
  let center = windowSize.vec2 / 2
  current_boxy.drawImage("ring1", center, angle = frame.float / 100)
  current_boxy.drawImage("ring2", center, angle = -frame.float / 190)
  current_boxy.drawImage("ring3", center, angle = frame.float / 170)

  current_boxy.endFrame()
  inc frame