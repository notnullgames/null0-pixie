import boxy
import wasm3
import wasm3/wasm3c
import std/options

import ./physfs
import ./imports/image

var current_boxy: Boxy

let windowSize* = ivec2(320, 240)
var null0_frame*: int

var null0_export_load:PFunction
var null0_export_update:PFunction
var null0_export_unload:PFunction
var null0_export_buttonDown:PFunction
var null0_export_buttonUp:PFunction


proc null0_setup_exports(runtime: PRuntime, debug:bool = false) =
  try:
    checkWasmRes m3_FindFunction(null0_export_update.addr, runtime, "update")
  except WasmError as e:
    if debug:
      echo "export update: ", e.msg
  try:
    checkWasmRes m3_FindFunction(null0_export_unload.addr, runtime, "unload")
  except WasmError as e:
    if debug:
      echo "export unload: ", e.msg
  try:
    checkWasmRes m3_FindFunction(null0_export_load.addr, runtime, "load")
  except WasmError as e:
    if debug:
      echo "export load: ", e.msg
  try:
    checkWasmRes m3_FindFunction(null0_export_buttonDown.addr, runtime, "buttonDown")
  except WasmError as e:
    if debug:
      echo "export buttonDown: ", e.msg
  try:
    checkWasmRes m3_FindFunction(null0_export_buttonUp.addr, runtime, "buttonUp")
  except WasmError as e:
    if debug:
      echo "export buttonUp: ", e.msg

proc null0_load*(cartBytes:string, bxy: Boxy, debug:bool = false) =
  current_boxy = bxy

  var e = physfs.init("null0")
  if e != 1:
    raise newException(IOError, "Could not initialize physfs")
  
  e = physfs.mountMemory(unsafeAddr cartBytes[0], int64 len(cartBytes), none(pointer), cstring "root", cstring "", cint 1)
  if e != 1:
    raise newException(IOError, "Could not mount physfs")
  
  var wasmBytes = readFilePhysfs("main.wasm")

  var env = m3_NewEnvironment()
  var runtime = env.m3_NewRuntime(uint32 uint16.high, nil)
  var module: PModule

  checkWasmRes m3_ParseModule(env, module.addr, cast[ptr uint8](unsafeAddr wasmBytes[0]), uint32 len(wasmBytes))
  checkWasmRes m3_LoadModule(runtime, module)

  null0_setup_imports(module, debug, bxy)
  null0_setup_exports(runtime, debug)
  

  # TODO: handle emscripten default exports and export similar in other wasm

  if null0_export_load != nil:
    null0_export_load.call(void)


proc null0_unload*() =
  if null0_export_unload != nil:
    null0_export_unload.call(void)
  discard physfs.deinit()


proc null0_update*(size:IVec2) =
  current_boxy.beginFrame(size)
  
  if null0_export_update != nil:
    null0_export_update.call(void, null0_frame)

  current_boxy.endFrame()
  inc null0_frame