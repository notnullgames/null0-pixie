This is a fun and easy game engine. It's cross-platform, and games (carts) can be run anywhere (native, web, etc) without recompiling.

All the demo-carts in this repo are written in nim for faster testing, but you can write them in any language that can compile to wasm.


```
# build runtime, then run it
nimble run

# run unit-tests
nimble test

# compile justlog cart
nimble cart justlog
```