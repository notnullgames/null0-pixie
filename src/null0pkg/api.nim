import boxy
import wasm3
import wasm3/wasm3c

import ./imports

var current_boxy: Boxy

let windowSize* = ivec2(320, 240)
var null0_frame*: int

var null0_export_load:PFunction
var null0_export_update:PFunction
var null0_export_unload:PFunction
var null0_export_buttonDown:PFunction
var null0_export_buttonUp:PFunction


proc null0_load*(wasmBytes:string, bxy: Boxy, debug:bool = false) =
  current_boxy = bxy

  var env = m3_NewEnvironment()
  var runtime = env.m3_NewRuntime(uint16.high.uint32, nil)
  var module: PModule

  checkWasmRes m3_ParseModule(env, module.addr, cast[ptr uint8](wasmBytes[0].unsafeAddr), uint32 len(wasmBytes))
  checkWasmRes m3_LoadModule(runtime, module)

  null0_setup_imports(module, bxy, debug)


  # EXPORTS
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

  # TODO: handle emscripten default exports and export similar in other wasm

  if null0_export_load != nil:
    null0_export_load.call(void)


proc null0_unload*() =
  if null0_export_unload != nil:
    null0_export_unload.call(void)


proc null0_update*() =
  current_boxy.beginFrame(windowSize)
  
  if null0_export_update != nil:
    null0_export_update.call(void, null0_frame)

  current_boxy.endFrame()
  inc null0_frame