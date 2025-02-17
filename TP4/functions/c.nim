import random, times, strformat

proc functionc*() =
  randomize()
  var count = 0
  while count < rand(3..7):
    echo count
    count += 1

# Appel direct de la fonction
functionc()
