import random, times, strformat

proc functiond*() =
  randomize()
  var arr: seq[int] = @[]
  for i in 0..rand(5..10):
    arr.add(rand(1..50))
  echo arr

# Appel direct de la fonction
functiond()
