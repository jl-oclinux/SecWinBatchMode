# SWMB - Secure Windows Mode Batch

Confidentilité et vie privée sur Windows 10 à l'aide de scripts Powershell.
Projet RESINFO / CNRS.

Document de référence :
[https://www.ssi.gouv.fr/administration/guide/restreindre-la-collecte-de-donnees-sous-windows-10/](https://www.ssi.gouv.fr/administration/guide/restreindre-la-collecte-de-donnees-sous-windows-10/)


## Scripts Powershell Disassembler0
Ce projet s'appuie sur le projet :
[https://github.com/Disassembler0/Win10-Initial-Setup-Script](https://github.com/Disassembler0/Win10-Initial-Setup-Script)
Ce project est ajouté en tant que subtree

```bash
git remote add -f Win10-Initial https://github.com/Disassembler0/Win10-Initial-Setup-Script.git
git subtree add --prefix Win10-Initial-Setup-Script/ Win10-Initial master --squash
```

Pour mettre à jour :

```bash
git subtree pull --prefix Win10-Initial-Setup-Script/ Win10-Initial master --squash
```


## Preset

Un preset  par paragraphe de l'ANSSI
 * preset Télémétrie
 * preset Cortana et search
 * preset Paramètres de personnalisation del'expérience utilisateur
 * preset Applications universelles
 * preset Cloud


## Usage

### Usage direct depuis PowerShell

```dos
.\Win10-Initial-Setup-Script\Win10.ps1 -include "Win10-Initial-Setup-Script\Win10.psm1" -include "Win10-Resinfo-swmb.psm1" nom-fonction
.\Win10-Initial-Setup-Script\Win10.ps1 -include "Win10-Initial-Setup-Script\Win10.psm1" -include "Win10-Resinfo-swmb.psm1 -preset Presets\UserExperience.preset
```

### Intégration dans un autre projet git


### Défintion de vos propres valeurs de variables

Si vous souhaitez définir vos propres valeurs de variables utilisées le script Win10-My-swmb.psm1, procédez de la façon suivante :
 * Créez un fichier nommé "Win10-MyVar-Post-swmb.psm1" dans le même répertoire que le script "Win10-MyVar-Pre-swmb.psm1"
 * Définissez les valeurs de vos variables et exportez les de la même façon que dans le fichier "Win10-MyVar-pre-swmb.psm1"
 * Exemple :
    ```ps
    $myLocalAdminNameToSet = "Ma valeur à moi que j'ai"
    Export-ModuleMember -Variable 'myLocalAdminNameToSet'
    ```
