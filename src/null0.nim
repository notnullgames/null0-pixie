import boxy, opengl, windy
import null0pkg/api
import docopt

const doc = """
null0 - Runtime for null0 game-engine

Usage:
  null0 --help
  null0 <cart>
  null0 -v <cart>

<cart>   Specify the cart-name (wasm file or zip/directory with main.wasm in it)

Options:
  -h --help               Show this screen.
  -v --verbose            Enable debugging text
"""

let args = docopt(doc, version = "0.0.1")
let cart = $args["<cart>"]

let window = newWindow("null0", windowSize)
makeContextCurrent(window)
loadExtensions()

let bxy = newBoxy()

let ratio = windowSize.x / windowSize.y
var scale = 1.0
var offset = vec2(0, 0)
var vs:Vec2
let ws = windowSize.vec2

null0_load(readFile(cart), bxy, args["--verbose"])

window.onFrame = proc() =
  vs = window.size.vec2
  if vs.x > (vs.y * ratio):
    scale = vs.y / ws.y
    offset.x = (vs.x - (ws.x * scale)) / 2
    offset.y = 0
  else:
    scale = vs.x / ws.x
    offset.y = (vs.y - (ws.y * scale)) / 2
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