import random, times, strformat

proc functionk*() =
  randomize()
  var text = "Hello"
  for c in text:
    echo ord(c)

# Appel direct de la fonction
functionk()
