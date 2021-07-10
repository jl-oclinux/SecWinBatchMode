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
 * Upstream project `Win10-Initial-Setup-Script` by Disassembler0 user :
   https://github.com/Disassembler0/Win10-Initial-Setup-Script
 * Document from the [ANSSI](https://fr.wikipedia.org/wiki/Agence_nationale_de_la_s%C3%A9curit%C3%A9_des_syst%C3%A8mes_d%27information)
   (Agence Nationale de la Sécurité des Systèmes d'Information - France) :
   [https://www.ssi.gouv.fr/administration/guide/restreindre-la-collecte-de-donnees-sous-windows-10/](https://www.ssi.gouv.fr/administration/guide/restreindre-la-collecte-de-donnees-sous-windows-10/)
 * Document of the [BSI](https://fr.wikipedia.org/wiki/Office_f%C3%A9d%C3%A9ral_de_la_s%C3%A9curit%C3%A9_des_technologies_de_l%27information)
   (Federal Office for Information Technology Security - Germany) :
   [https://www.bsi.bund.de/SharedDocs/Downloads/EN/BSI/Cyber-Security/SiSyPHuS/AP11/Hardening_Guideline.pdf](https://www.bsi.bund.de/SharedDocs/Downloads/EN/BSI/Cyber-Security/SiSyPHuS/AP11/Hardening_Guideline.pdf)

More references on the page [REFERENCES](./REFERENCES.md).


## Preset

Un preset par paragraphe de l'ANSSI
 * preset Télémétrie
 * preset Cortana et search
 * preset Paramètres de personnalisation de l'expérience utilisateur
 * preset Applications universelles
 * preset Cloud


## Usage

### Direct use from PowerShell

```ps1
# Execution of a single function
.\swmb.ps1 NomFonction

# Execution of a preset
.\swmb.ps1 -preset "Presets\UserExperience-Resinfo.preset"
```

### Integrated use in a PowerShell script

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

### Integration into another Git project

One way to use SWMB is to integrate it in one of your projects as a Git subtree.
```bash
git remote add -f SWMB https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb.git
git subtree add --prefix SWMB/ SWMB master --squash
```

To update (synchronize) your repository with the SWMB project repository:
```bash
git subtree pull --prefix SWMB/ https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb.git master --squash
```

See [CONTRIBUTING](./CONTRIBUTING.md).


### Definition of your own variable values

If you want to define your own variable values used in the `Custom.psm1` module, do the following:
 * Create a file named `Custom-VarOverload.psm1` in the same directory as the `Custom-VarDefault.psm1` module,
   or in any parent `..` or sub-folder `Modules` of a parent folder!
   This leaves a lot of choices...
 * Set the hash values of your global variables
   (Don't change the whole hash table like in the `Custom-VarDefault.psm1` file)
 * Example:
   ```ps
   $Global:SWMB_Custom.NTP_ManualPeerList = "0.fr.pool.ntp.org, 1.fr.pool.ntp.org"
   ```
Order in which the `Custom-VarOverload.psm1` module will be loaded into memory:
 1. `..\Custom-VarOverload.psm1`
 1. `..\Modules\Custom-VarOverload.psm1`
 1. `..\..\Custom-VarOverload.psm1`
 1. `..\..\Modules\Custom-VarOverload.psm1`
 1. and so on...

For sensitive keys, it is possible to define a `Custom-VarAutodel.psm1` module.
This one works exactly the same way as the `Custom-VarOverload.psm1` module
except that SWMB **deletes this module file** for security reasons right **after loading** it into memory.
So it is only valid once unless you recreate it between two SWMB launches.

The module `Custom-VarAutodel.psm1` is searched in the same folder as the module `Custom-VarOverload.psm1`.
The `VarOverload` module **is loaded first** if it exists, however **both modules are loaded if they are in the same folder**.
The recursive search in subfolders stops as soon as one or both modules are found in a folder.


## Examples of deployment and use

You will find, in the [dists](dists) directory, examples of deployment of the script
(manual, at machine startup, with OCS Inventory, volume encryption...).

The [README](dists/manual-use/README.md) file in the "manual-use" directory
reminds some principles about Powershell execution policies.
