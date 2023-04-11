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
  Vec2* = array[2, int]

proc vec2*(x:int, y: int):Vec2 =
  return [x,y]

const windowSize* = vec2(320, 240)
const windowCenter* = vec2(160, 120)


# ##################################
# imported C API, for use in carts #
# ##################################

# similar to echo, but simpler, and works cross-host
proc trace*(text: cstring) {.importc, cdecl.}

# load a named image
proc load_image*(name: cstring, filename: cstring = "") {.importc, cdecl.}
