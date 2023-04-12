import boxy, opengl, windy
import null0pkg/api
import docopt

const doc = """
null0 - Runtime for null0 game-engine

Usage:
  null0 --help
  null0 <cart>

<cart>   Specify the cart-name (wasm file or zip/directory with main.wasm in it)

Options:
  -h --help               Show this screen. 
"""

let window = newWindow("null0", windowSize)
makeContextCurrent(window)
loadExtensions()

let bxy = newBoxy()

let ratio = windowSize.x / windowSize.y
var scale = 1.0
var offset = vec2(0, 0)
var fX:float
var fY:float

let args = docopt(doc, version = "0.0.1")
let cart = $args["<cart>"]

null0_load(readFile(cart), bxy, true)

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