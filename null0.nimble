# Package

version       = "0.0.0"
author        = "David Konsumer"
description   = "A fun and easy game engine"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["null0"]

requires "nim >= 1.6.10"
requires "boxy >= 0.4.1"
requires "windy >= 0.0.0"
requires "opengl >= 1.2.7"