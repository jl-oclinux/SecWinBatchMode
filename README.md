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
The objective is to be able to easily deploy security tweaks (strategy) on a computer park,
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
SWMB is mainly based on the tweaks enacted by the French National Agency for Information Systems Security ([ANSSI](https://www.ssi.gouv.fr/)).
There are thus three levels of possible tweaks in SWMB:
 * `Modules\SWMB\Win10` - tweaks extracted from the ANSSI documentation, or from certain instructions of the RSSI of the CNRS,
    applicable in the whole ESR (Higher Education and Research in France);
 * `Modules\SWMB\Custom` - interesting tweaks that you can extend for your site.
 * `Modules\SWMB\Experimental` - future tweaks under active development and not fully tested.
    Feedback from users may be interesting.

Each tweak can be enabled (`enable`) or disabled (`disable`) very easily in a configuration file (`preset`).
Sample files are available.
Each tweak is associated with a comment in French or English referring to its origin.
The French language has sometimes been chosen in order to follow the ANSSI's terminology
and because of the French version of Windows 10 which is used in most of our computers in the ESR.

For `Custom` tweaks, it is possible to set them with a variable file in order to adapt them to your park.
A set of default parameters is proposed.
The other tweaks are not configurable, because they are, at first, to take or to leave!
The upstream project on which we based ourselves had not planned to be able to parameterize tweaks.
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


## Installation

You can find on https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/ the latest versions of the SWMB installer.
These setup packages are made with the NSIS software.

It is possible to do a silent installation with the `/S` flag.


## Usage

### Direct use from PowerShell

```ps1
# Execution of a single function / tweak
.\swmb.ps1 NameOfTheTweak

# Execution of a preset of tweaks
.\swmb.ps1 -preset "Presets\LocalMachine-Default.preset"
```

### Integrated use in a PowerShell script

```ps1
# Loading the SWMB base engine with all the main modules (neested)
# Put only SWMB.psm1 if you want only the core
Import-Module Modules\SWMB.psd1

# Initialize
SWMB_Init

# Load a preset file (can be called several times)
# Each preset file is a suite of tweaks
SWMB_LoadTweakFile "Presets\LocalMachine-Default.preset"

# Load one tweak (can be called multiple times)
# Unloads the tweak if it ends with the - sign
SWMB_AddOrRemoveTweak "NomFonction"

# If you want to check the consistency of tweaks
SWMB_CheckTweaks

# Execute all loaded tweaks (presets)
SWMB_RunTweaks
```

### Command line option

`swmb.ps1` currently supports the following parameters:
 * `-core` : if used, it must be the first option.
   Import only the core (minimal) module `SWMB.psm1`,
   not all the neested module declared in `SWMB.psd1`.
 * `-include module_file` : imports the module into SWMB.
   You can extend SWMB, as is, with your own tweaks.
   This option can be declare as many times as necessary.
 * `-preset preset_file` : loads all the tweak groups defined in a preset file.
   This option can be declared as many times as necessary.
 * `-log log_file` : messages will be written to the log file file
   and not in the terminal.
 * `-check` : does not execute the tweaks but only checks if they exist
   (in accordance with the preset file).
 * `-exp` : this is just a shortcut to import the `Experimental.psm1` module.
   This option is mainly used by developers to help test new tweaks.

### Tasks

The goal is not to change anything in the SWMB installation folder.
Two scheduled tasks are configured.
One takes place at machine startup (Boot) and the other at user login (Logon).

These two tasks will look for their parameters in the `C:\ProgramData\SWMB\Presets` folder.
 * CurrentUser-Logon.ps1 - Load preset at user logon `C:\ProgramData\SWMB\Presets\CurrentUser-Logon.preset`
 * LocalMachine-Boot.ps - Load preset  at boot `C:\ProgramData\SWMB\Presets\LocalMachine-Boot.preset`

If a module with the same name (with extension `.psm1`) exist in the folder `C:\ProgramData\SWMB\Modules`,
it's will be import.

An event is created in Application journal at begin and end of the task.
Output of the task are redirected in a log file inside the folder `C:\ProgramData\SWMB\Logs`.

Two preset `CurrentUser-Logon-Test.preset` and `LocalMachine-Boot-Test.preset`
are copied on folder `C:\ProgramData\SWMB\Presets`.
They could serve for test or as simple example.
Do not modify these examples directly, they will be updated in the next software update.
Rename them and modify them.


## Preset

The preset file is in practice a list of tweaks to apply.
There is one tweak per line.
It is possible to have empty lines, comments.
These are identified with the # character, as in many scripting languages.

The presets are classified in the folder `Presets`.
Currently, there is one preset per paragraph of the ANSSI concerning the settings for the computer configuration.
 * Telemetry preset
 * Cortana and search preset
 * User experience preset
 * Universal Applications preset
 * Cloud preset

Moreover, some presets concern the computer while others concern the current user.
In one case, the tweaks affect the overall operation of the operating system and must be run as an administrator (or under the SYSTEM user),
in the other case, the actions are to be launched, for example at login, with the identity of the person.
Preset files are therefore prefixed with the extensions `LocalMachine-` and `CurrentUser-`.

It is possible to include a set of presets in another file with the keyword `$INCLUDE` (same keyword as in the freeradius server software configuration).
The preset `LocalMachine-Default.preset` gathers all the recommended presets mentioned above for the machine.
It is currently not possible to have a space in the path name (it is always possible to put a wildcard like a `*` or a `?` to get around it).
```ps1
$INCLUDE LocalMachine-Cloud.preset
$INCLUDE LocalMachine-CortanaSearch.preset
...
```
In order to facilitate the deployment,
the modularity and the management of programmed tasks,
it is also possible to import a module within a preset file, with the keyword `$IMPORT`.
This is the same way as the `$INCLUDE` keyword.
Note the support of wildcards in the name of the module to import, allowing to import several of them.
The module path must be relative to the preset file.
It is currently not possible to have a space in the path name (it is always possible to put a wildcard like a `*` or a `?` to get around it).
```ps1
$IMPORT ..\Modules\MyModule.psm1
```
You can import as many modules as you want.


### Definition of your own variable values

If you want to define your own variable values used in the `Custom.psm1` module, do the following:
 * Create a file named `Custom-VarOverload.psm1` in the same directory as the `Custom-VarDefault.psm1` module,
   or in any parent `..` or sub-folder `Modules` of a parent folder!
   This leaves a lot of choices...
   It's also possible to create it inside the program data folder dedicated to SWMB
   (`C:\ProgramData\SWMB\Modules`).
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
 1. `C:\ProgramData\SWMB\Custom-VarOverload.psm1`
 1. `C:\ProgramData\SWMB\Modules\Custom-VarOverload.psm1`

For sensitive keys, it is possible to define a `Custom-VarAutodel.psm1` module.
This one works exactly the same way as the `Custom-VarOverload.psm1` module
except that SWMB **deletes this module file** for security reasons right **after loading** it into memory.
So it is only valid once unless you recreate it between two SWMB launches.

The module `Custom-VarAutodel.psm1` is searched in the same folder as the module `Custom-VarOverload.psm1`.
The `VarOverload` module **is loaded first** if it exists, however **both modules are loaded if they are in the same folder**.
The recursive search in subfolders stops as soon as one or both modules are found in a folder.


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


## Examples of deployment and use

You find on https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/ last packages made with NSIS Setup.

You will find, in the [dists](dists) directory, examples of deployment of the script
(manual, at machine startup, with OCS Inventory, volume encryption...).

The [README](dists/manual-use/README.md) file in the "manual-use" directory
reminds some principles about Powershell execution policies.
