{.passC: "-Ivendor/gamepad/source".}

{.compile: "vendor/gamepad/source/gamepad/Gamepad_private.c".}

when defined(macosx):
  {.compile: "vendor/gamepad/source/gamepad/Gamepad_macosx.c".}

when defined(linux):
  {.compile: "vendor/gamepad/source/gamepad/Gamepad_linux.c".}

when defined(windows):
  {.compile: "vendor/gamepad/source/gamepad/Gamepad_windows_dinput.c".}
  {.compile: "vendor/gamepad/source/gamepad/Gamepad_windows_mm.c".}

type
  Gamepad_device* {.bycopy.} = object
    deviceID*: cuint
    description*: cstring
    vendorID*: cint
    productID*: cint
    numAxes*: cuint
    numButtons*: cuint
    axisStates*: ptr cfloat
    buttonStates*: ptr bool
    privateData*: pointer
  
  cbAttach = proc (device: ptr Gamepad_device; context: pointer)
  cbButton = proc (device: ptr Gamepad_device; buttonID: cuint; timestamp: cdouble; context: pointer)
  cbAxis = proc (device: ptr Gamepad_device; axisID: cuint; value: cfloat; lastValue: cfloat; timestamp: cdouble; context: pointer)


{.push callconv: cdecl, importc:"Gamepad_$1".}
proc init*()
proc shutdown*()
proc numDevices*(): cuint
proc deviceAtIndex*(deviceIndex: cuint): ptr Gamepad_device
proc detectDevices*()
proc processEvents*()
proc deviceAttachFunc*(callback: cbAttach; context: pointer)
proc deviceRemoveFunc*(callback: cbAttach; context: pointer)
proc buttonDownFunc*(callback: cbButton; context: pointer)
proc buttonUpFunc*(callback: cbButton; context: pointer)
proc axisMoveFunc*(callback: cbAxis; context: pointer)
{.pop.}