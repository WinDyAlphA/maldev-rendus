import random, times, strformat

proc functiona*() =
  randomize()
  var sum = 0
  for i in 1..rand(5..10):
    sum += i
  echo sum

# Appel direct de la fonction
functiona()
