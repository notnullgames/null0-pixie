import boxy
import wasm3
import wasm3/wasm3c

var current_boxy: Boxy

proc null0Import_trace(runtime: PRuntime; ctx: PImportContext; sp: ptr uint64; mem: pointer): pointer {.cdecl.} =
  proc procImpl(text: cstring) =
    echo text
  var s = sp.stackPtrToUint()
  callHost(procImpl, s, mem)

proc null0Import_load_image(runtime: PRuntime; ctx: PImportContext; sp: ptr uint64; mem: pointer): pointer {.cdecl.} =
  proc procImpl(name: cstring, filename: cstring) =
    echo "load_image: " & $name & ", " & $filename
  var s = sp.stackPtrToUint()
  callHost(procImpl, s, mem)


proc null0_setup_imports*(module: PModule, bxy: Boxy, debug: bool = false) =
  current_boxy = bxy

  # IMPORTS
  try:
    checkWasmRes m3_LinkRawFunction(module, "*", "trace", "v(*)", null0Import_trace)
  except WasmError as e:
    if debug:
      echo "import trace: ", e.msg
  
  try:
    checkWasmRes m3_LinkRawFunction(module, "*", "load_image", "v(**)", null0Import_load_image)
  except WasmError as e:
    if debug:
      echo "import load_image: ", e.msg