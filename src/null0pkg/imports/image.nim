import boxy
import wasm3
import wasm3/wasm3c
import ../physfs

var current_boxy: Boxy

proc readImagePhysfs(filePath: string):Image =
  return decodeImage(readFilePhysfs(filePath))

proc null0Import_trace(runtime: PRuntime; ctx: PImportContext; sp: ptr uint64; mem: pointer): pointer {.cdecl.} =
  proc procImpl(text: cstring) =
    echo text
  var s = sp.stackPtrToUint()
  callHost(procImpl, s, mem)

proc null0Import_load_image(runtime: PRuntime; ctx: PImportContext; sp: ptr uint64; mem: pointer): pointer {.cdecl.} =
  proc procImpl(key: cstring, filename: cstring) =
    current_boxy.addImage($key, readImagePhysfs($filename))
  var s = sp.stackPtrToUint()
  callHost(procImpl, s, mem)



proc null0_setup_imports*(module: PModule, debug: bool, bxy: Boxy) =
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
