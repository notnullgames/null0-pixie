# ######################################
# this is the cart-side header for nim #
# ######################################

import std/[macros]

# macro for your exports that creates an emscripten export
macro null0*(t: typed): untyped =
  if t.kind notin {nnkProcDef, nnkFuncDef}:
    error("Can only export procedures", t)
  let
    newProc = copyNimTree(t)
    codeGen = nnkExprColonExpr.newTree(ident"codegendecl", newLit"EMSCRIPTEN_KEEPALIVE $# $#$#")
  if newProc[4].kind == nnkEmpty:
    newProc[4] = nnkPragma.newTree(codeGen)
  else:
    newProc[4].add codeGen
  newProc[4].add ident"exportC"
  result = newStmtList()
  result.add:
    quote do:
      {.emit: "/*INCLUDESECTION*/\n#include <emscripten.h>".}
  result.add:
    newProc

# ######################################################
# some types, consts, and helpers to make things nicer #
# ######################################################

type
  Vec2* = array[2, int32]

proc vec2*(x:int32, y: int32):Vec2 =
  return [x, y]

const windowSize* = vec2(320, 240)
const windowCenter* = vec2(160, 120)


# ##################################
# imported C API, for use in carts #
# ##################################

# similar to echo, but simpler, and works cross-host
proc trace*(text: cstring) {.importc, cdecl.}

# load a named image
proc load_image*(name: cstring, filename: cstring) {.importc, cdecl.}

# draw a named image
proc draw_image*(key: cstring, posX:int32, posY:int32, angle: float32 = 0) {.importc, cdecl.}


# ############################################
# wrappers around C API to make things nicer #
# ############################################

proc draw_image*(key: cstring, pos: Vec2, angle: float32 = 0) =
  draw_image(key, pos[0], pos[1], angle)
