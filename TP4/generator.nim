import random, strformat, os

if not dirExists("functions"):
  createDir("functions")

const operations = [
  """  var x = rand(1..100)
  var y = rand(1..100)
  echo x + y""",
  """  var arr: seq[int] = @[]
  for i in 0..rand(5..10):
    arr.add(rand(1..50))
  echo arr""",
  """  var s = ""
  for i in 0..rand(3..8):
    s.add(chr(rand(65..90)))
  echo s""",
  """  var count = 0
  while count < rand(3..7):
    echo count
    count += 1""",
  """  echo "Function called at: ", now()""",
  """  var nums = @[1, 2, 3, 4, 5]
  for num in nums:
    echo num * rand(1..5)""",
  """  var text = "Hello"
  for c in text:
    echo ord(c)""",
  """  var sum = 0
  for i in 1..rand(5..10):
    sum += i
  echo sum""",
  """  var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  echo chars[rand(0..25)]""",
  """  echo fmt"Random value: {rand(1..1000)}\""""
]

# Génère 15 fichiers
for i in 0..14:
  let 
    letter = chr(ord('a') + i)
    filename = fmt"functions/{letter}.nim"
  let content = fmt"""import random, times, strformat

proc function{letter}*() =
  randomize()
{sample(operations)}

# Appel direct de la fonction
function{letter}()
"""
  writeFile(filename, content)

echo "15 fichiers de fonctions ont été générés dans le dossier 'functions/'" 