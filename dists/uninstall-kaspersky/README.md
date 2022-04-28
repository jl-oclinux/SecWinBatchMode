# Uninstall Kaspersky Endpoint

Create a file `Custom-VarOverload.psm1` in your current folder
```
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

How to create a password encrypted so blurred ?

A small script is provided [set-password-encrypted.ps1](set-password-encrypted.ps1).
It asks you for a file name to store the encryption key and password.
The blurred encrypted word will then be displayed on the console.
You have to write these values in the `Custom-VarOverload.psm1` file.
Finally, the file containing the encryption key should be put next
to the file of this configuration file (in the same folder).

You can verify that this password is encrypted by doing the reverse
operation via the [get-password-cleartext.ps1](get-password-cleartext.ps1) script.

Finally, regardless of the method chosen for the password,
the Kapersky uninstallation operation is launched
with the following command ([uninstall-kaspersky.ps1](uninstall-kaspersky.ps1)):
```ps1
"C:\Program Files\SWMB\swmb.ps1" -exp UninstallKasperskyEndpoint
```


To learn more about [encrypting credentials](https://www.pdq.com/blog/secure-password-with-powershell-encrypting-credentials-part-1/).
