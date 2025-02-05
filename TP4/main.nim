import os, strutils, strformat, random

proc generateXorKey(): array[3, int] =
    return [rand(0..255), rand(0..255), rand(0..255)]

proc generateXorStrings(key: array[3, int]): tuple[user32, messageBox: string] =
    let 
        user32 = "user32.dll"
        messageBox = "MessageBoxA"
    var user32Xor, messageBoxXor = ""
    
    for i, c in user32:
        user32Xor.add("\\x" & toHex(ord(c) xor key[i mod 3], 2))
    for i, c in messageBox:
        messageBoxXor.add("\\x" & toHex(ord(c) xor key[i mod 3], 2))
    
    return (user32Xor, messageBoxXor)

proc generatePolymorphicVersion() =
    randomize()
    let key = generateXorKey()
    let (user32Xor, messageBoxXor) = generateXorStrings(key)
    var newCode = "import winim\nimport strutils\n\n"
    var xorString = fmt"""
proc xorString(input: string): string =
    const key: array[3, byte] = [{key[0]:#02x},{key[1]:#02x},{key[2]:#02x}]
    var output = newStringOfCap(input.len)
    for i, ch in input:
        let keyByte = key[i mod key.len]
        output.add(chr(ord(ch) xor int(keyByte)))
    return output
    """
    var getApiAddress = """
proc getApiAddress(libNameXor, funcNameXor: string): pointer =
  let libName = xorString(libNameXor)
  let funcName = xorString(funcNameXor)
  let hModule = LoadLibraryA(libName)
  if hModule == 0:
    echo "Erreur lors du chargement de la librairie: ", libName
    return nil
  result = GetProcAddress(cast[HMODULE](hModule), funcName)
  if result == nil:
    echo "Erreur lors de la récupération de la fonction: ", funcName
    """
    var mainproc = fmt"""
const
  messageBox_xor = "{messageBoxXor}"    # MessageBoxA  
  user32_xor = "{user32Xor}"    # user32.dll
  
proc MessageBoxA(hwnd: pointer, text, caption: cstring, flags: UINT): int32 {{.stdcall, dynlib: "user32.dll", importc: "MessageBoxA".}}

let msgBoxPtr = getApiAddress(user32_xor, messageBox_xor)
if msgBoxPtr != nil:
  let MessageBoxDyn = cast[proc(hwnd: pointer, text, caption: cstring, flags: UINT): int32 {{.stdcall.}}](msgBoxPtr)
  discard MessageBoxDyn(nil, "Oteria", "Obfuscated IAT", 0)
else:
  echo "Impossible de résoudre l'adresse de MessageBoxA"
    """
    newCode.add(xorString & "\n\n")
    newCode.add(getApiAddress & "\n\n")
    newCode.add(mainproc & "\n")
    let newFileName = "TP4/polymorphic_" & $rand(1000..9999) & ".nim"
    writeFile(newFileName, newCode)
    discard execShellCmd("nim c -d:release " & newFileName)

generatePolymorphicVersion()