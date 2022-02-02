# NEWS

## Version 3.14 (in progress)

The string `Tweak` has been added in front of the name of all tweak functions.
This means that preset files can no longer call standard Powershell functions.
If needed, a specific tweak function must be written for security reasons.

New presets/rules:
* 2022/02/02 - EnableASLR/DisableASLR -> Address Space Layout Randomisation


## Version 3.13 (2021/11/22)

Add a setup file, juste write `make pkg` under Linux (Add a `Makefile`).
Continuous integration build the package,
see https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/.
A Zip file is created for OCS Inventory.
A Zip file is also created for WAPT package.
You can use it as-is.

Add a minimal UI with `wisemoui.ps1` program. Launch it via the Start Menu.

Automatically search `Overload` and `Autodel` module in `C:\ProgramData\SWMB` folder
(and `Modules` subfolder).

Create two tasks:
* `CurrentUser-Logon.ps1` - Execute at user logon `C:\ProgramData\SWMB\Presets\CurrentUser-Logon.preset`
* `LocalMachine-Boot.ps` - Execute at boot `C:\ProgramData\SWMB\Presets\LocalMachine-Boot.preset`

If a module with the same name exist in `C:\ProgramData\SWMB\Modules`, it's will be launch.

An event is created in Application at begin and end.
Output is redirect in a log file inside the folder `C:\ProgramData\SWMB\Logs`.

Two presets `CurrentUser-Logon-Test.preset` and `LocalMachine-Boot-Test.preset`
are copied on folder `C:\ProgramData\SWMB\Presets`.
They could serve for test or as simple examples.

Two presets [CurrentUser-Logon-Recommanded.preset](Presets/CurrentUser-Logon-Recommanded.preset)
and [LocalMachine-Boot-Recommanded.preset](Presets/LocalMachine-Boot-Recommanded.preset)
are copied on folder `C:\ProgramData\SWMB\Presets`
with the names `CurrentUser-Logon.preset` and `LocalMachine-Boot.preset`.
They are execute at logon (account SYSTEM) and at boot (account CurrentUser).
Configuration tweaks are thus performed on any workstation that installs SWMB.
These tweaks are selected by the SWMB working group (RESINFO).
The default boot preset is not empty.
If you don't want any tweaks, replace these two files with empty ones
or don't activate them with the installer.
On the command line you can do this with:
```ps1
SWMB-Setup-XXX.exe /S /ACTIVATED_PRESET=0
```
Any value other than 0 (or nothing) will activate the default preset.

New presets/rules:
* 2021/10/21 - $PRESET and $IMPORT can open absolute and relative path file (before only relative path was possible)
* 2021/10/21 - $PRESET replace $INCLUDE to include a preset file.
* 2021/10/20 - SysCheckpoint - Make a system checkpoint if possible (max one per day)
* 2021/10/19 - $INCLUDE ($PRESET) and $IMPORT can open filename with space in PATH. Protect the string with double quote `"`.
* 2021/10/16 - SysBox - Like SysMessage but open a Box (experimental)
* 2021/10/15 - SysEvent - Like SysMessage but send an Event
* 2021/10/11 - $IMPORT - Like $PRESET but import a module from a preset file

New CLI parameter:
* `-import` replace `-include` to be more clear.
  As `$PRESET` replace `$INCLUDE` in preset file.
  The word `include` is not use anymore because sometime it was on modules and sometime on preset files.
* `-hash filename` makes a hash of the tweak list (preset)
  and compares it with the old hash stored in filename.
  If the hashes differ, a system checkpoint is performed.
  A folder `Caches` is created in `C:\ProgramData\SWMB`
  to store all the hashes.
* `-version` print the program version.

New module architecture, Win10- prefix has been replaced by LocalMachine-.
This is better for the new Windows 11 operating system.


## Version 3.12 (2021/09/14)

Rename main program Win10.ps1 to swmb.ps1
Add a compatibility program for upgrade Win10.ps1

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
* 2021/09/10 - DisableMSHTMLActiveX/EnableMSHTMLActiveX/View... Disable ActiveX in MSHTML (Internet Explorer) CVE-2021-40444
* 2021/08/28 - DisableAutoloadDriver/EnableAutoloadDriver -> Zero day on autoload driver on network
* 2021/07/10 - SysRequireAdmin replace RequireAdmin
* 2021/07/07 - SysAutoUpgrade - Auto Upgrade your SWMB folder! Need an internet access to the Git repository
* 2021/07/02 - DisablePrintForSystem/EnablePrintForSystem/ViewPrintForSystem -> Pseudo patch for CVE-2021-34527
* 2021/06/14 - EnableInsecureGuestLogons/DisableInsecureGuestLogons -> Disable by default
* 2021/06/13 - DisableSMB1Protocol/EnableSMB1Protocol -> SMBv1 protocol
* 2021/06/13 - DisableSMB1/EnableSMB1 rename -> DisableSMB1Server/EnableSMB1Server
* 2021/06/05 - SetNTPConfig/UnsetNTPConfig - NTP service configuration
* 2021/06/05 - EnableGodMod_CU/EnableGodMod_CU - God Mod for Current user
* 2021/06/05 - Rename Restart -> SysRestart and WaitForKey -> SysPause
* 2021/06/05 - SysHalt - Halt computer and not Reboot
* 2021/06/04 - SysMessage - Just write a message on terminal for debugging purpose (like WaitForKey)
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
