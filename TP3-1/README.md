# maldev-rendus TP 3-1

## Description

un main en Nim qui va être le malware
un fichier AgentHelpers.py a remplacer dans le C2 (fonctions de chiffrement adaptées)

> :warning: **Il faut remplacer AgentHelper.py a la racine du C2Template OteriaHackC2**: Sinon ca ne marchera pas !

## Comment run ?

Remplacez bien le AgentHelpers.py, puis lancez votre listener
une fois ceci fais, changez la constante base_url dans main.nim (l:11) avec l'adresse ip de votre C2

lancez sur la machine victime le malware avec directement

```nim c --run .\main.nim```

ou compilez d'abord le nim pour n'avoir que le .exe sur la machine cible 

```nim c .\main.nim```