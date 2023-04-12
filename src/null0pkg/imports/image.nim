import boxy
import wasm3
import wasm3/wasm3c
import ../physfs

type
  WasmVect2 {.byref,packed.} = object
    x: int32
    y: int32

  WasmColor {.byref,packed.} = object
    b: uint8
    g: uint8
    r: uint8
    a: uint8

proc fromWasm*(result: var WasmVect2, sp: var uint64, mem: pointer) =
  var i: uint32
  i.fromWasm(sp, mem)
  result = cast[ptr WasmVect2](cast[uint64](mem) + i)[]

proc fromWasm*(result: var WasmColor, sp: var uint64, mem: pointer) =
  var i: uint32
  i.fromWasm(sp, mem)
  result = cast[ptr WasmColor](cast[uint64](mem) + i)[]

proc vec2(i: WasmVect2): Vec2 =
  return vec2(float i.x, float i.y)

proc rgba(i: WasmColor): ColorRGBA =
  return rgba(i.r, i.g, i.b, i.a)

const fontDefault = staticRead("../../font_default.png")

var current_boxy: Boxy

proc readImagePhysfs(filePath: string):Image =
  return decodeImage(readFilePhysfs(filePath))

proc null0Import_load_image(runtime: PRuntime; ctx: PImportContext; sp: ptr uint64; mem: pointer): pointer {.cdecl.} =
  proc procImpl(key: cstring, filename: cstring) =
    current_boxy.addImage($key, readImagePhysfs($filename))
  var s = sp.stackPtrToUint()
  callHost(procImpl, s, mem)

proc null0Import_draw_image(runtime: PRuntime; ctx: PImportContext; sp: ptr uint64; mem: pointer): pointer {.cdecl.} =
  proc procImpl(key: cstring, pos:WasmVect2, angle: float32) =
    current_boxy.drawImage($key, vec2(float pos.x, float pos.y), angle)
  var s = sp.stackPtrToUint()
  callHost(procImpl, s, mem)

proc null0Import_path_filled(runtime: PRuntime; ctx: PImportContext; sp: ptr uint64; mem: pointer): pointer {.cdecl.} =
  proc procImpl(key: cstring, pathString: cstring, color: WasmColor, size: WasmVect2) =
    let path = parsePath($pathString)
    var bounds: Rect
    if size.x == 0 or size.y == 0:
      bounds = computeBounds(path)
    else:
      bounds = rect(vec2(0.0,0.0), vec2(size))
    let image = newImage(int bounds.w + bounds.x, int bounds.h + bounds.y)
    image.fillPath(path, rgba(color.r, color.g, color.b, color.a))
    current_boxy.addImage($key, image)
  var s = sp.stackPtrToUint()
  callHost(procImpl, s, mem)

proc null0Import_path_stroked(runtime: PRuntime; ctx: PImportContext; sp: ptr uint64; mem: pointer): pointer {.cdecl.} =
  proc procImpl(key: cstring, pathString: cstring, color: WasmColor, strokeWidth: float32, size: WasmVect2) =
    let path = parsePath($pathString)
    var bounds: Rect
    if size.x == 0 or size.y == 0:
      bounds = computeBounds(path)
    else:
      bounds = rect(vec2(0.0,0.0), vec2(size))
    let image = newImage(int bounds.w + bounds.x + (strokeWidth * 2), int bounds.h + bounds.y + (strokeWidth * 2))
    image.strokePath(path, rgba(color.r, color.g, color.b, color.a), mat3(), strokeWidth)
    current_boxy.addImage($key, image)
  var s = sp.stackPtrToUint()
  callHost(procImpl, s, mem)


proc null0_setup_imports*(module: PModule, debug: bool, bxy: Boxy) =
  current_boxy = bxy
  
  try:
    checkWasmRes m3_LinkRawFunction(module, "*", "load_image", "v(**)", null0Import_load_image)
  except WasmError as e:
    if debug:
      echo "import load_image: ", e.msg

  try:
    checkWasmRes m3_LinkRawFunction(module, "*", "draw_image", "v(**f)", null0Import_draw_image)
  except WasmError as e:
    if debug:
      echo "import draw_image: ", e.msg

  try:
    checkWasmRes m3_LinkRawFunction(module, "*", "path_filled", "v(****)", null0Import_path_filled)
  except WasmError as e:
    if debug:
      echo "import path_filled: ", e.msg

  try:
    checkWasmRes m3_LinkRawFunction(module, "*", "path_stroked", "v(***f*)", null0Import_path_stroked)
  except WasmError as e:
    if debug:
      echo "import path_filled: ", e.msg
