import random, times, strformat

proc functioni*() =
  randomize()
  var text = "Hello"
  for c in text:
    echo ord(c)

# Appel direct de la fonction
functioni()
