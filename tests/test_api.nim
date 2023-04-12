# To run these tests, simply execute `nimble test`.

import unittest
import boxy

import null0pkg/api

test "exports windowSize":
  check windowSize == ivec2(320, 240)
