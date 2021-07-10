# NEWS

## Version 3.12

New modules architecture:
* `Modules/SWMB.psd1` - Generic preload module (`Modules/SWMB.psm1`)
* `Modules/SWMB/Custom.psm1` - Additionnal rules with parameter
* `Modules/SWMB/Resinfo.psm1` - ANSSI rules
* `Modules/SWMB/Experimental.psm1` - Experimentals rules
* `Modules/SWMB/Win10-*.psm1` - Initial module from Disassembler0
* `Modules/SWMB/CurrentUser-*.psm1` - Initial module from Disassembler0 base on HKCU
* `Modules/SWMB/TemporaryBypass.psm1` - Temporary Bypass Strategy Module

Parameter module now use global hash table (via the `*-VarOverload.psm1` plugin).
Automatically search `Overload` variable module in parent folder.
Added support for the `Autodel` plugin in addition to the `Overload` plugin.
As the name suggests, the plug-in file `*-VarAutodel.psm1` will be deleted right after loading.

Add View* function to help debugging

New dists:
* [crypt-with-bitlocker](./dists/crypt-with-bitlocker/)

New CLI parameter:
* `-core`  - Load minimal SWMB code module. Must be the first parameter
* `-check` - Check for duplicated tweak preset and tweak implementations. Do not execute any preset
* `-exp`  - Load Experimental module (add Experimental feature)

New preset selection:
* Post-Install.preset - Enable Bitlocker after installation
* Current-User.preset - Preset for Current User and not Local Machine
* System-Resinfo.preset - Preset on system and network
* LocalMachine-*.preset - Rename *-Resinfo.preset file for local machine tweak
* LocalMachine-Default.preset - New global preset file with $INCLUDE directive

Preset file could now include other files with the $INCLUDE directive

New presets/rules:
* 2021/07/07 - SysAutoUpgrade - Auto Upgrade your SWMB folder! Need an internet access to the Git repository
* 2021/07/02 - DisablePrintForSystem/EnablePrintForSystem/ViewPrintForSystem -> Pseudo patch for CVE-2021-34527
* 2021/06/14 - EnableInsecureGuestLogons/DisableInsecureGuestLogons -> Disable by default
* 2021/06/13 - DisableSMB1Protocol/EnableSMB1Protocol -> SMBv1 protocol
* 2021/06/13 - DisableSMB1/EnableSMB1 rename -> DisableSMB1Server/EnableSMB1Server
* 2021/06/05 - SetNTPConfig/UnsetNTPConfig - NTP service configuration
* 2021/06/05 - EnableGodMod_CU/EnableGodMod_CU - God Mod for Current user
* 2021/06/05 - Rename Restart -> SysRestart and WaitForKey -> SysPause
* 2021/06/05 - SysHalt - Halt computer and not Reboot
* 2021/06/04 - SysMsg - Just write a message on terminal for debugging purpose (like WaitForKey)
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
