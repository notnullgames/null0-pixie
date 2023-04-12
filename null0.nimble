# Package

version       = "0.0.0"
author        = "David Konsumer"
description   = "A fun and easy game engine"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["null0"]
skipDirs      = @["carts/*"]

requires "nim >= 1.6.10"
requires "boxy >= 0.4.1"
requires "windy >= 0.0.0"
requires "opengl >= 1.2.7"
requires "https://github.com/beef331/wasm3 >= 0.1.7"
requires "docopt >= 0.7.0"

import std/os
import std/strutils
import std/strformat

# TODO: these should be more cross-platform

task clean, "Cleans up files":
  exec "rm -f null0 *.wasm *.null0 tests/test_api"

task cart, "Build a demo cart":
  let name = paramStr(paramCount())
  let dir = "src/carts/" & name
  exec(fmt"cd {dir} && nim c main.nim && zip ../../../{name}.null0 -r main.wasm assets/ -x '*.DS_Store' && mv main.wasm ../../../{name}.wasm")
