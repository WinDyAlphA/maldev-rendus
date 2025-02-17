import random, times, strformat

proc functione*() =
  randomize()
  var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  echo chars[rand(0..25)]

# Appel direct de la fonction
functione()
