import random, times, strformat

proc functiono*() =
  randomize()
  echo "Function called at: ", now()

# Appel direct de la fonction
functiono()
