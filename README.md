# swmb

Confidentilité et vie privée sur Windows 10 à l'aide de scripts Powershell

Document de référence :
[https://www.ssi.gouv.fr/administration/guide/restreindre-la-collecte-de-donnees-sous-windows-10/](https://www.ssi.gouv.fr/administration/guide/restreindre-la-collecte-de-donnees-sous-windows-10/)



## Scripts Powershell Disassembler0
Ce projet s'appuie sur le projet :
[https://github.com/Disassembler0/Win10-Initial-Setup-Script](https://github.com/Disassembler0/Win10-Initial-Setup-Script)
Ce project est ajouté en tant que subtree

    git remote add -f Win10-Initial https://github.com/Disassembler0/Win10-Initial-Setup-Script.git
    git subtree add --prefix Win10-Initial-Setup-Script/ Win10-Initial master --squash

Pour mettre à jour :

    git subtree pull --prefix Win10-Initial-Setup-Script/ Win10-Initial master --squash


## preset
Un preset  par paragraphe de l'ANSSI
    preset Télémétrie
    preset Cortana et search
    preset Paramètres de personnalisation del'expérience utilisateur
    preset Applications universelles
    preset Cloud

## Usage

### Usage direct depuis PowerShell

.\Win10-Initial-Setup-Script\Win10.ps1 -include "Win10-Initial-Setup-Script\Win10.psm1" -include "Win10-Resinfo-swmb.ps1"  nom-fonction
.\Win10-Initial-Setup-Script\Win10.ps1 -include "Win10-Initial-Setup-Script\Win10.psm1" -include "Win10-Resinfo-swmb.ps1 -preset Presets/preset-resinfo.txt


### Intégration dans un autre projet git
