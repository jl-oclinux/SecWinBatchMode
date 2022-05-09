# Uninstall Kaspersky Endpoint

## Liminary

There is a tweak in SWMB that allows you to uninstall the Kasperksy
Endpoint software and the Network Agent: `UninstallKasperskyEndpoint`.
However, removing such software is not easy because an antivirus
program always protects itself against viruses,
so the easy uninstallation...

**Warning**: There is another tweak, `UninstallKasperskyConsole`,
which allows you to remove the Kaspersky Console software.
This one is not uninstalled via the present scripts.
However, it is easy to adapt it or to make another equivalent
to also remove this console.

## Quick and Standalone version

There is an independent SWMB version of this tweak to make the
uninstallation of Kasperky Endpoint even easier.

Just download this [Zip archive](https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/Kasperky-Uninstall-Latest.zip).

Then, in the directory where the archive is extracted,
in a PowerShell console with administrator rights,
we launch the following command which, despite its name,
will uninstall Kaspersky.
```ps1
.\install.bat 
```
It will ask you to run the command
```ps1
.\set-password-encrypted.ps1
```
because the Zip archive does not contain the files with the key
and the settings module to give the kaspersky password.
Then we restart the uninstallation with again
```ps1
.\install.bat
```

To automate this on a computer park, you just have to put the file
containing the encryption key and the `Custom-VarAutodel.psm1` file
in the Zip archive and then deploy this archive
by running `install.bat` during this one (for example with OCS Inventory).

*For information*, the name of the script is install.bat because during
an automatic deployment, at LEGI, we always run the `install.bat` name script
of the archive, whatever the script actually does!
In this case, nothing is installed.
In case of deployment with OCS for example,
there will be nothing left of these files (OCS extracts the Zip archives
in a temporary folder that it destroys at the end)...

*Note*: it is possible to use the `set-password-encrypted.ps1`
(and `get-password-cleartext.ps1`) script to prepare the uninstallation
environment (the Zip archive or equivalent) with an encrypted password under Windows,
but also under MacOSX or GNU/Linux OSes by installing
[PowerShell](https://docs.microsoft.com/fr-fr/powershell/scripting/install/installing-powershell)
(command `pwsh`).

*WAPT*: The Zip archive is also compatible with a [WAPT](https://www.wapt.fr) package system
(there are `setup.py` and `control` files inside).
So it is possible to push this package on your WAPT package server
(if you configure it as explained above).

## Configuration module

Therefore, you need a password to ensure this operation.
This password is local to each site.
You will have to configure / customize your SWMB installation
before you can uninstall kaspersky Endpoint.

This includes the creation of a parameter module
`Custom-VarOverload.psm1` which can be saved in the current folder
or in any other folder...
```ps1
# Kaspersky Endpoint Security
$Global:SWMB_Custom.KesLogin        = "KLAdmin"

# If clear password
$Global:SWMB_Custom.KesPassword     = ""

# Or if encrypted blurred password
$Global:SWMB_Custom.KesSecureString = ""
$Global:SWMB_Custom.KesKeyFile      = ""
```
You can choose to put the password to modify Kasperky in clear text
or to scramble it via a symmetric encryption process.

For safety, you can put this data in a configuration file `Custom-VarAutodel.psm1`.
The advantage with this is that it is destroyed after use.
So the password will not remain written in a file on the workstation,
even if encrypted, after the uninstallation.

## What's in this folder

How to create a password encrypted so blurred ?

A small script is provided [set-password-encrypted.ps1](set-password-encrypted.ps1).
It asks you for a file name to store the encryption key and password.
The blurred encrypted word will then be displayed on the console.
You have to write these values in the `Custom-VarOverload.psm1` file (or `Custom-VarAutodel.psm1`).
Finally, the file containing the encryption key should be put next
to the file of this configuration file (in the same folder).

You can verify that this password is encrypted by doing the reverse
operation via the [get-password-cleartext.ps1](get-password-cleartext.ps1) script.

Finally, regardless of the method chosen for the password,
the Kapersky uninstallation operation is launched with
the tweak `UninstallKasperskyEndpoint`
It's resume with the following command
([uninstall-kaspersky.ps1](uninstall-kaspersky.ps1)):
```ps1
. "C:\Program Files\SWMB\swmb.ps1" -exp UninstallKasperskyEndpoint
```

## In practice

Basically, on a workstation, all you have to do is open a PowerShell
console as an administrator, then run the script
```ps1
cd "C:\Program Files\SWMB\dists\uninstall-kaspersky"

.\set-password-encrypted.ps1

.\uninstall-kaspersky.ps1
```
And that's it,
Kaspersky Endpoint disappears from the computer... hopefully!

To automate the procedure on a group of machines, you need to deploy SWMB,
copy this uninstall script, the encryption key and the configuration
module to the same folder (this is simpler, but not mandatory),
and that should be enough.

There are two versions of the `uninstall-kaspersky` file,
one uses the `swmb.ps1` engine and the other one uses the minimum
while being independent (standalone).

## More

To learn more about [encrypting credentials](https://www.pdq.com/blog/secure-password-with-powershell-encrypting-credentials-part-1/).

Get all Kaspersky programs installed on a computer
```ps1
Get-WmiObject win32_product|Where { $_.name -like "*Kaspersky*" }
```

Example of display on a french installation.
PLease note that the `UninstallKasperskyEndpoint` tweak uninstall the
Kasperksy Endpoint software and the Network Agent,
but not all Kaspersky software!
```
IdentifyingNumber : {2924BEDA-E0D7-4DAF-A224-50D2E0B12F5B}
Name              : Agent d'administration de Kaspersky Security Center
Vendor            : Kaspersky
Version           : 12.0.0.7734
Caption           : Agent d'administration de Kaspersky Security Center

IdentifyingNumber : {7EC66A9F-0A49-4DC0-A9E8-460333EA8013}
Name              : Kaspersky Endpoint Security for Windows
Vendor            : AO Kaspersky Lab
Version           : 11.6.0.394
Caption           : Kaspersky Endpoint Security for Windows

IdentifyingNumber : {5D35D57A-30B9-493B-819F-C6C2181A0A1A}
Name              : Console d'administration de Kaspersky Security Center
Vendor            : Kaspersky
Version           : 13.2.0.1511
Caption           : Console d'administration de Kaspersky Security Center
```
