import random, times, strformat

proc functionn*() =
  randomize()
  var x = rand(1..100)
  var y = rand(1..100)
  echo x + y

# Appel direct de la fonction
functionn()
