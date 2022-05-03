# Uninstall Kaspersky Endpoint

## Liminary

There is a tweak in SWMB that allows you to uninstall the Kasperksy
Endpoint software: `UninstallKasperskyEndpoint`.
However, removing such software is not easy because an antivirus
program always protects itself against viruses,
so the easy uninstallation...

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

## More

To learn more about [encrypting credentials](https://www.pdq.com/blog/secure-password-with-powershell-encrypting-credentials-part-1/).
