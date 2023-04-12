import boxy, opengl, windy
import null0pkg/api

let window = newWindow("null0", windowSize)
makeContextCurrent(window)
loadExtensions()

let bxy = newBoxy()

let ratio = windowSize.x / windowSize.y
var scale = 1.0
var offset = vec2(0, 0)
var fX:float
var fY:float

null0_load(readFile("draw.null0"), bxy, true)

window.onFrame = proc() =
  fX = float(window.size.x)
  fY = float(window.size.y)
  if float(window.size.x) > (fY * ratio):
    scale = window.size.y / windowSize.y
    offset.x = (fX - (float(windowSize.x) * scale)) / 2
    offset.y = 0
  else:
    scale = window.size.x / windowSize.x
    offset.y = (fY - (float(windowSize.y) * scale)) / 2
    offset.x = 0

  bxy.beginFrame(window.size)
  bxy.saveTransform()
  bxy.translate(offset)
  bxy.scale(scale)
  null0_update()
  bxy.restoreTransform()
  bxy.endFrame()
  window.swapBuffers()

while not window.closeRequested:
  pollEvents()
  

null0_unload()