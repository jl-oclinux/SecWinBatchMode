# Chiffrer le disque système et les autres volumes avec Microsoft Bitlocker
Contrairement à la majorité des Presets proposés par SWMB,
celui-ci ne doit être réalisé qu'une seule fois.
Génréralement, nous allons faire cette étape de chiffrement lors de l'installation de l'ordinateur,
à la fin de celle-ci.
# Pré-requis
Pour fonctionner correctement, le script nécessite quelques pré-requis
* Etre exécuté avec un compte administrateur et élévation de privilèges
* Le bios doit être en UEFI
* Le secure boot doit être activé
* L'ordinateur doit disposer d'un TPM
# Exécution
Voici 2 méthodes pour lancer le script.

La deuxième méthode est simplement un script qui exécute automatiquement les commandes de la méthode 1.
## Méthode 1
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

.\Win10.ps1 EnableBitlocker
```
Il est possible de vérifier le statut du lecteur système
```ps
manage-bde -status C:
```
## Méthode 2
* Télécharger les fichiers swmb-bitlocker-launcher.bat et swmb-bitlocker-launcher.ps1 de ce répertoire
* Editer ces 2 fichiers et les lire! Il convient de le faire pour tout script téléchargé depuis internet!
* Clic-droit sur swmb-bitlocker-launcher.bat et "Exécuter en tant qu'administrateur"
* And voilà!
