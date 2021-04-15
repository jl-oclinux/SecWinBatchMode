# Chiffrer le disque système et les autres volumes avec Microsoft Bitlocker

Contrairement à la majorité des Presets proposés par SWMB,
celui-ci ne doit être réalisé qu'une seule fois.
Génréralement, nous allons faire cette étape de chiffrement lors de l'installation de l'ordinateur,
à la fin de celle-ci.

Ouvrir dans une fenêtre PowerShell ayant des privilèges élevés (exécuter en tant qu'administrateur)

```ps
mkdir C:\SWMB
cd C:\SWMB
wget 'https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb/-/archive/master/resinfo-swmb-master.zip' `
	-OutFile 'resinfo-swmb-master.zip'

Expand-Archive -LiteralPath 'resinfo-swmb-master.zip' -DestinationPath C:\SWMB

dir -Path C:\SWMB\resinfo-swmb-master -Recurse | Unblock-File

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

cd C:\SWMB\resinfo-swmb-master

.\Win10-Initial-Setup-Script\Win10.ps1 `
	-include "Win10-Initial-Setup-Script\Win10.psm1" `
	-include "Win10-Resinfo-Swmb.psm1" `
	-include "experimental\bitlocker-activation.psm1" `
	EnableBitlocker
```

Il est possible de vérifier le statut du lecteur système
```ps
manage-bde –status C:
```
