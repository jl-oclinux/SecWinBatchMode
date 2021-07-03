# SWMB - Secure Windows Mode Batch

 * [CONTRIBUTING](./CONTRIBUTING.md)
 * [FAQ](./FAQ.md)
 * [LICENSE](./LICENSE.md)
 * [NEWS](./NEWS.md)
 * [REFERENCES](./REFERENCES.md)
 * [USE CASE (distribution)](./dists/README.md)

## Preamble

SWMB is a project from the SWMB working group of the RESINFO business network of CNRS and the French higher education.
It is about managing security, confidentiality and privacy under the Windows 10 operating system with the help of scripts,
thus without using a graphical interface.
The objective is to be able to easily deploy security rules (strategy) on a computer park,
whether or not the computers are in an Active Directory domain.
In a concern of tracing (quality) and knowledge sharing, all possible actions are readable in a text format.
The chosen programming language is Microsoft Powershell.
All the code and documentation is available on a Git forge.

The choice to implement a scripting system is therefore a complementary choice to a solution with GPO associated with Active Directory servers.
The question of how SWMB is deployed on the workstations is not directly linked to the SWMB project itself.
It is software like any other and can therefore be integrated into any configuration management system.

The project is intended to be modular.
It must be easy to maintain, easy to understand, easy to extend and easy to use.
The website https://www.ghacks.net/2015/08/14/comparison-of-windows-10-privacy-tools/ references many possible solutions.
SWMB chose to take as a starting point the code of Disassembler0 which is now archived: `Win10-Initial-Setup-Script`,
because it met all our criteria above.

Regarding the applicable security strategies,
SWMB is mainly based on the rules enacted by the French National Agency for Information Systems Security ([ANSSI](https://www.ssi.gouv.fr/)).
There are thus three levels of possible rules in SWMB:
 * `Modules\SWMB\Win10` - rules extracted from the ANSSI documentation, or from certain instructions of the RSSI of the CNRS,
    applicable in the whole ESR (Higher Education and Research in France);
 * `Modules\SWMB\Custom` - interesting rules that you can extend for your site.
 * `Modules\SWMB\Experimental` - future rules under active development and not fully tested.
    Feedback from users may be interesting.
 
 
Each rule can be enabled (`enable`) or disabled (`disable`) very easily in a configuration file (`preset`).
Sample files are available.
Each rule is associated with a comment in French or English referring to its origin.
The French language has sometimes been chosen in order to follow the ANSSI's terminology
and because of the French version of Windows 10 which is used in most of our computers in the ESR.

For `Custom` rules, it is possible to set them with a variable file in order to adapt them to your park.
A set of default parameters is proposed.
The other rules are not configurable, because they are, at first, to take or to leave!
The upstream project on which we based ourselves had not planned to be able to parameterize rules.
It is an extension that we added.

**Some references**:
 * Upstream project `Win10-Initial-Setup-Script` :
   https://github.com/Disassembler0/Win10-Initial-Setup-Script
 * Document from the [ANSSI](https://fr.wikipedia.org/wiki/Agence_nationale_de_la_s%C3%A9curit%C3%A9_des_syst%C3%A8mes_d%27information)
   (Agence Nationale de la Sécurité des Systèmes d'Information - France) :
   [https://www.ssi.gouv.fr/administration/guide/restreindre-la-collecte-de-donnees-sous-windows-10/](https://www.ssi.gouv.fr/administration/guide/restreindre-la-collecte-de-donnees-sous-windows-10/)
 * Document of the [BSI](https://fr.wikipedia.org/wiki/Office_f%C3%A9d%C3%A9ral_de_la_s%C3%A9curit%C3%A9_des_technologies_de_l%27information)
   (Federal Office for Information Technology Security - Germany) :
   [https://www.bsi.bund.de/SharedDocs/Downloads/EN/BSI/Cyber-Security/SiSyPHuS/AP11/Hardening_Guideline.pdf](https://www.bsi.bund.de/SharedDocs/Downloads/EN/BSI/Cyber-Security/SiSyPHuS/AP11/Hardening_Guideline.pdf)

More references on the page [REFERENCES](./REFERENCES.md).


## Scripts Powershell Disassembler0

Ce projet s'appuie sur le projet :
[https://github.com/Disassembler0/Win10-Initial-Setup-Script](https://github.com/Disassembler0/Win10-Initial-Setup-Script)
Ce projet est ajouté en tant que `subtree`.

```bash
git remote add -f Win10-Initial https://github.com/Disassembler0/Win10-Initial-Setup-Script.git
git subtree add --prefix Win10-Initial-Setup-Script/ Win10-Initial master --squash
```

Pour mettre à jour :

```bash
git subtree pull --prefix Win10-Initial-Setup-Script/ https://github.com/Disassembler0/Win10-Initial-Setup-Script.git master --squash
```

Voir [CONTRIBUTING](./CONTRIBUTING.md).

## Preset

Un preset par paragraphe de l'ANSSI
 * preset Télémétrie
 * preset Cortana et search
 * preset Paramètres de personnalisation de l'expérience utilisateur
 * preset Applications universelles
 * preset Cloud


## Usage

### Usage direct depuis PowerShell

```ps1
# Exécution d'une fonction seule
.\Win10.ps1 NomFonction

# Exécution d'un jeu de preset
.\Win10.ps1 -preset "Presets\UserExperience-Resinfo.preset"
```

### Usage intégré dans un script PowerShell

```ps1
# Load core SWMB engine
Import-Module Modules\SWMB.psd1

# Initialize
SWMB_Init

# Load a preset file (could be call multiple times)
SWMB_LoadTweakFile "Presets\UserExperience-Resinfo.preset"

# Load one preset (could be call multiple times)
SWMB_AddOrRemoveTweak "NomFonction"

# If you want to check consistency
SWMB_CheckTweaks

# Execute all presets
SWMB_RunTweaks
```

### Intégration dans un autre projet Git


### Définition de vos propres valeurs de variables

Si vous souhaitez définir vos propres valeurs de variables utilisées le module `Custom.psm1`, procédez de la façon suivante :
 * Créez un fichier nommé `Custom-VarOverload.psm1` dans le même répertoire que le module `Custom-VarDefault.psm1`,
   ou dans n'importe quel dossier parent `..` ou sous dossier `Modules` d'un dossier parent !
   Cela laisse pas mal de choix...
 * Définissez les valeurs du hash de vos variables globales
   (Ne modifiez pas toute la table de hashage comme dans le fichier `Custom-VarDefault.psm1`)
 * Exemple :
   ```ps
   $Global:SWMB_Custom.NTP_ManualPeerList = "0.fr.pool.ntp.org, 1.fr.pool.ntp.org"
   ```


## Exemples de déploiement et d'utilisation

Vous trouverez, dans le répertoire [dists](dists), des exemples de déploiement du script
(manuel, au démarrage de la machine, avec OCS Inventory, chiffrement des volumes...).

Le fichier [README](dists/manual-use/README.md) du répertoire «manual-use» rappelle quelques principes sur les politiques d'exécution de Powershell.
