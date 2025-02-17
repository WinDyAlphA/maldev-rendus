import random, times, strformat

proc functionb*() =
  randomize()
  echo "Function called at: ", now()

# Appel direct de la fonction
functionb()
