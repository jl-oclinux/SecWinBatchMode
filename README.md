# SWMB - Secure Windows Mode Batch

## Préambule

SWMB est un projet issu du groupe de travail SWMB du réseaux métier RESINFO du CNRS.
Il s'agit de gérer la sécurité, la confidentilité et la vie privée sous l'OS Windows 10 à l'aide de scripts.
L'objectif est de pouvoir déployer facilement sur un parc informatique des règles de sécurité (stratégie)
que les postes soient ou ne soient pas dans un Active Directory.
Dans un soucis de traçage (qualité) et de partage des connaissances, toutes les actions possibles sont lisibles dans un format texte.
Le langage de programmation choisit est le Powershell de Microsoft.
L'ensemble du code et de la documentation est accessible sur une forge Git.

Le choix de réaliser un système de scripts est donc un choix complémentaire d'une solution avec GPO associée au clickdrome Active Directory.

Le projet se veut modulaire.
Il doit être facile à maintenir, facile à comprendre, facile à maintenir et facile à utiliser.
Le site https://www.ghacks.net/2015/08/14/comparison-of-windows-10-privacy-tools/ référence de nombreuses solutions possibles.
SWMB a fait le choix de prendre pour base le code de Disassembler0 :  `Win10-Initial-Setup-Script`,
car celui-ci répondait à tous nos critères ci-dessus.

En ce qui concerne les stratégies de sécurité applicables,
SWMB s'appuie principalement sur les règles édictées par l'Agence Nationale de la Sécurité des Systèmes d'Information (ANSSI).
Il y a ainsi dans SWMB trois niveaux de règles possibles :
 * `Win10-Initial-Setup` - règles du projet amont non modifiées
 * `Win10-Resinfo-swmb` - règles extraites de la documentation de l'ANSSI, ou de certaines consignes du RSSI du CNRS, applicable dans tout l'ESR (Enseignement Supérieur et Recherche)
 * `Win10-My-swmb` - règles intéréssantes que vous pouvez étentdre pour votre site
Chaque règle peut-être activé (`enable`) ou déactivé (`disable`) très facilement dans un fichier de configuration (`preset`).
Des fichiers types sont proposés.
À chaque règle est associée un commentaire en français faisant référence à son origine.
Le français a été choisis afin de suivre le vocable de l'ANSSI
et de part la version française de Windows 10 équipant la majorité de notre parc informatique.

Pour les règles `Win10-My-swmb`, il est possible de les paramétrer avec un fichier de variable afin de les adapter à votre parc.
Un jeu de paramètres par défaut est proposé.
Les autres règles ne sont pas paramétrable car elles sont, dans un premier temps, à prendre ou à laisser !
Le projet amont sur lequel nous nous appuyons n'avait d'ailleurs pas prévu de pouvoir paramétrer des règles.

Document de référence de l'ANSSI :
[https://www.ssi.gouv.fr/administration/guide/restreindre-la-collecte-de-donnees-sous-windows-10/](https://www.ssi.gouv.fr/administration/guide/restreindre-la-collecte-de-donnees-sous-windows-10/)


## Scripts Powershell Disassembler0

Ce projet s'appuie sur le projet :
[https://github.com/Disassembler0/Win10-Initial-Setup-Script](https://github.com/Disassembler0/Win10-Initial-Setup-Script)
Ce project est ajouté en tant que `subtree`.

```bash
git remote add -f Win10-Initial https://github.com/Disassembler0/Win10-Initial-Setup-Script.git
git subtree add --prefix Win10-Initial-Setup-Script/ Win10-Initial master --squash
```

Pour mettre à jour :

```bash
git subtree pull --prefix Win10-Initial-Setup-Script/ Win10-Initial master --squash
```


## Preset

Un preset par paragraphe de l'ANSSI
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

### Intégration dans un autre projet Git


### Définition de vos propres valeurs de variables

Si vous souhaitez définir vos propres valeurs de variables utilisées le script `Win10-My-swmb.psm1`, procédez de la façon suivante :
 * Créez un fichier nommé `Win10-MyVar-Post-swmb.psm1` dans le même répertoire que le script `Win10-MyVar-Pre-swmb.psm1`
 * Définissez les valeurs de vos variables et exportez les de la même façon que dans le fichier `Win10-MyVar-pre-swmb.psm1`
 * Exemple :
    ```ps
    $myLocalAdminNameToSet = "Ma valeur à moi"
    Export-ModuleMember -Variable 'myLocalAdminNameToSet'
    ```
