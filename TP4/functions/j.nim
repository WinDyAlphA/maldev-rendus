import random, times, strformat

proc functionj*() =
  randomize()
  var s = ""
  for i in 0..rand(3..8):
    s.add(chr(rand(65..90)))
  echo s

# Appel direct de la fonction
functionj()
