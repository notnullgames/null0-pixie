proc load*() {.null0.} =
  trace("Hello from draw.")
  load_image("ring1", "assets/ring1.png")
  load_image("ring2", "assets/ring2.png")
  load_image("ring3", "assets/ring3.png")
  path_filled("heart", """
    M 20 60
    A 40 40 90 0 1 100 60
    A 40 40 90 0 1 180 60
    Q 180 120 100 180
    Q 20 120 20 60
    z
  """, PINK)

proc update*(frame: int) {.null0.} =
  draw_image("heart", windowCenter)
  draw_image("ring1", windowCenter, float(frame) / 100)
  draw_image("ring2", windowCenter, -float(frame) / 190)
  draw_image("ring3", windowCenter, float(frame) / 170)

proc unload*() {.null0.} =
  trace("Ok, bye.")