import random, times, strformat

proc functionf*() =
  randomize()
  var text = "Hello"
  for c in text:
    echo ord(c)

# Appel direct de la fonction
functionf()
