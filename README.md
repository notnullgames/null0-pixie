This is a fun and easy game engine. It's cross-platform, and games (carts) can be run anywhere (native, web, etc) without recompiling.

All the demo-carts in this repo are written in nim for faster testing, but you can write them in any language that can compile to wasm.


```
# get this repo and it's submodules
git clone --recursive git@github.com:notnullgames/null0-pixie.git
cd null0-pixie


# compile draw cart
nimble cart draw

# compile justlog cart
nimble cart justlog

# build runtime, then run it on draw.null0
nimble run -- draw.null0

```
