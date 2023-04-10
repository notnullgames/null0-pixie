import boxy, opengl, windy
import null0/api

let window = newWindow("null0", windowSize)
makeContextCurrent(window)
loadExtensions()

let bxy = newBoxy()

null0_load(bxy)

while not window.closeRequested:
  null0_update(bxy)
  pollEvents()
  window.swapBuffers()
