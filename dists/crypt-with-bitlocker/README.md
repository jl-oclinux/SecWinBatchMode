# Encrypt system disk and other volumes with Microsoft Bitlocker

Unlike most of the presets offered by SWMB,
this one has to be done only once.
Generally, we will do this encryption step during the installation of the computer,
at the end of it.


## Prerequisites

To work properly, the script requires a few pre-requisites:
* To be executed with an administrator account and elevation of privileges
* The BIOS must be in UEFI
* Secure boot must be enabled
* The computer must have a TPM


## Execution

Here are 2 methods to run the script.
The second method is simply a script that automatically executes the commands in method 1.

### Method 1

Open in a PowerShell window with elevated privileges (run as administrator)

```ps
mkdir C:\SWMB
cd C:\SWMB
wget 'https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb/-/archive/master/resinfo-swmb-master.zip' `
	-OutFile 'resinfo-swmb-master.zip'

Expand-Archive -LiteralPath 'resinfo-swmb-master.zip' -DestinationPath C:\SWMB

dir -Path C:\SWMB\resinfo-swmb-master -Recurse | Unblock-File

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

cd C:\SWMB\resinfo-swmb-master

.\swmb.ps1 EnableBitlocker
```

It is possible to check the status of the system drive
```ps
manage-bde -status C:
```

### Method 2

* Download the files `swmb-bitlocker-launcher.bat` and `swmb-bitlocker-launcher.ps1` from this directory
* Edit these two files and read them!
  This should be done for any script downloaded from the internet!
* Right-click on `swmb-bitlocker-launcher.bat` and "Run as administrator"
* And that's it!
