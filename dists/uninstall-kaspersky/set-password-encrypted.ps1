
$KeyFile = Read-Host -Prompt "Key File"
$Password = Read-Host -AsSecureString -Prompt "Password to secure"

$Key = New-Object Byte[] 32 # create key AES 256-bit key (32 bytes)
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | Out-File $KeyFile

$EncryptedPass = ConvertFrom-SecureString -SecureString $Password -Key $Key

Write-Output ""
Write-Output "# Lines to add in your configuration file Custom-VarOverload.psm1"
Write-Output ""
Write-Output "`$Global:SWMB_Custom.KesSecureString = '$EncryptedPass'"
Write-Output "`$Global:SWMB_Custom.KesKeyFile      = '$KeyFile'"
Write-Output ""

If (!(Test-Path -LiteralPath ".\Custom-VarOverload.psm1")) {
	$Query = Read-Host -Prompt "Do you want to create a configration file in the current folder [Y|n]"
	If ($Query.ToLower() -ne "n") {
		Write-Output "
# Configuration for Kaspersky Endpoint
`$Global:SWMB_Custom.KesSecureString = '$EncryptedPass'
`$Global:SWMB_Custom.KesKeyFile      = '$KeyFile'
" | Out-File -FilePath ".\Custom-VarOverload.psm1" -NoClobber
	}
} Else {
	$Query = Read-Host -Prompt "Do you want to append theses parameters in your current configuration file [Y|n]"
	If ($Query.ToLower() -ne "n") {
		Write-Output "
# Configuration for Kaspersky Endpoint
`$Global:SWMB_Custom.KesSecureString = '$EncryptedPass'
`$Global:SWMB_Custom.KesKeyFile      = '$KeyFile'
" | Out-File -FilePath ".\Custom-VarOverload.psm1" -Append
	}
}
