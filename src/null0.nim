import boxy, opengl, windy
import null0pkg/api

let window = newWindow("null0", windowSize)
makeContextCurrent(window)
loadExtensions()

let bxy = newBoxy()

null0_load(readFile("draw.null0"), bxy, true)

while not window.closeRequested:
  null0_update(window.size)
  pollEvents()
  window.swapBuffers()

null0_unload()