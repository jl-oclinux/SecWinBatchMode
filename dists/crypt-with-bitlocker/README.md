# Crypt system drive and other drive in a nutshell with bitlocker

Contrairement à la majorité des Presets proposés par SWMB,
celui-ci ne doit être réalisés qu'une seule fois.
Génréralement, nous allons faire cette étape de chiffrement lors de l'installation de l'ordinateur.

Ouvrir dans une fenêtre PowerShell avec privilèges élevés (exécuter en tant qu'administrateur)

```ps
mkdir C:\SWMB
cd C:\SWMB
wget 'https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb/-/archive/master/resinfo-swmb-master.zip' -OutFile 'resinfo-swmb-master.zip'

Expand-Archive -LiteralPath 'resinfo-swmb-master.zip' -DestinationPath C:\SWMB

dir -Path C:\SWMB\resinfo-swmb-master -Recurse | Unblock-File

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

cd C:\SWMB\resinfo-swmb-master

.\Win10-Initial-Setup-Script\Win10.ps1 `
	-include "Win10-Initial-Setup-Script\Win10.psm1" `
	-include "Win10-Resinfo-Swmb.psm1" `
	-include "experimental/bitlocker-activation.psm1" `
	EnableBitlocker
```

Il est possible de vérifier le statut du lecteur système
```ps
manage-bde –status C:
```
