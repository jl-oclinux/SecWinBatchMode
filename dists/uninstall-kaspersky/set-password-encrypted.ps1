
$KeyFile = Read-Host -Prompt "Key File"
$Password = Read-Host -AsSecureString -Prompt "Password to secure"

$Key = New-Object Byte[] 32 # create key AES 256-bit key (32 bytes)
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | Out-File $KeyFile

$EncryptedPass = ConvertFrom-SecureString -SecureString $Password -Key $Key

Write-Output ""
Write-Output "`$Global:SWMB_Custom.KesSecureString = '$EncryptedPass'"
Write-Output "`$Global:SWMB_Custom.KesKeyFile      = '$KeyFile'"
Write-Output ""
