# Uninstall Kaspersky Endpoint

Create a file `Custom-VarOverload.psm1` in the current folder
```
# Kaspersky Endpoint Security
$Global:SWMB_Custom{'KesLogin'}        = "KLAdmin"

# If clear password
$Global:SWMB_Custom{'KesPassword'}     = ""

# Or if blurred password
$Global:SWMB_Custom{'KesSecureString'} = ""
$Global:SWMB_Custom{'KesKeyFile'}      = ""
```

You can choose to put the Kasperky password in the clear
or to blur it via a symmetric encryption process.

Howto create a blurred password ?

A small script is provided `blur-password.ps1`.
It asks you for a file name to save the encryption key and the password.
The blurred word will be displayed on the console.

You can check that this password is blurred by doing the reverse
operation via the `clear-password.ps1` script.

You can choose to put the password to modify Kasperky in clear text
or to scramble it via a symmetric encryption process.

How to create a blurred password?

A small script is provided `blur-password.ps1`.
It asks you for a file name to store the encryption key and password.
The blurred word will then be displayed on the console.

You can verify that this password is blurred by doing the reverse
operation via the `clear-password.ps1` script.

Finally, regardless of the method chosen for the password,
the Kapersky uninstallation operation is launched
with the following command:
```ps1
"C:\Program Files\SWMB\swmb.ps" -exp RemoveKasperskyEndpoint
```


To learn more about [encrypting credentials](https://www.pdq.com/blog/secure-password-with-powershell-encrypting-credentials-part-1/).
