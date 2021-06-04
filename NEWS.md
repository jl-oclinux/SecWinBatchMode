# NEWS

## Version 3.12

New modules architecture:
* `Modules/SWMB.psd1` - Generic preload module (`Modules/SWMB.psm1`)
* `Modules/SWMB/Custom.psm1` - Additionnal rules with parameter
* `Modules/SWMB/Resinfo.psm1` - ANSSI rules
* `Modules/SWMB/Win10.psm1` - Initial module from Disassembler0

Parameter module now use global hash table.
Automatically search Overload variable module in parent folder.

New dists:
* [crypt-with-bitlocker](./dists/crypt-with-bitlocker/)

New preset selection:
* Post-Install.preset - Enable Bitlocker after installation

New presets/rules:
* 2021/06/04 - DisableUWPAccessLocation/EnableUWPAccessLocation - Let UWP Apps Access Location
* 2021/06/01 - DisableWindowsFeeds/EnableWindowsFeeds - News and Interests on Taskbar
* 2021/05/12 - EnableBitlocker/DisableBitlocker - Crypt hard drive with bitlocker
* 2021/04/29 - DisableWindowsHello/EnableWindowsHello - Windows Hello Authentification


## Version 3.11 (never publish)

All ANSSI rules integration.

First paramter module implementation with global variable.

New dists folder with use case examples.

New presets selection:
* Cloud-Resinfo.preset
* CortanaSearch-Resinfo.preset
* Post-Install.preset
* Telemetry-Resinfo.preset
* UniversalApps-Resinfo.preset
* UserExperience-Resinfo.preset


## Version 3.10

Initial version from Disassembler0 `Win10-Initial-Setup-Script` project
