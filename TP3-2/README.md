# maldev-rendus TP 3-2

## Description

un fichier dll.nim dans client_code qui va créer une dll et executer le shellcode (calc.exe)
un fichier python dans server_code qui sert a générer le shellcode chiffré

> :warning: **Il faut avoir un serveur qui peut ditribuer le shellcode chiffré**: Sinon ca ne marchera pas !  

## Comment run ?

Changez les lignes 28 dans client_code/dll.nim afin d'être en accord avec les paramètres de votre serveur

Lancez le fichier python dans server_code sur le serveur afin de generer le shellcode

Lancez votre serveur en écoute sur le bon port 

Vous pouvez générer la dll avec cette commande : 

```nim c -d=mingw --app=lib --nomain --cpu=amd64 .\dll.nim```

Il suffit ensuite de renommer votre dll avec une extension en .cpl

La machine victime a juste a double-cliquer sur ce cpl pour télécharger et executer ce shellcode

