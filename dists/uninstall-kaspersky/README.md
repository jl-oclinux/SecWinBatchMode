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

Howto create a blurred password ?


Launch the command
```ps1
"C:\Program Files\SWMB\swmb.ps" -exp RemoveKasperskyEndpoint
```
