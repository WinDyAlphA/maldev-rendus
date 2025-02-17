import random, times, strformat

proc functiong*() =
  randomize()
  var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  echo chars[rand(0..25)]

# Appel direct de la fonction
functiong()
