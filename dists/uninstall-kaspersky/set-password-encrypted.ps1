
$KeyFile = Read-Host -Prompt "Key File (please put .key extension)"
$Password = Read-Host -AsSecureString -Prompt "Password to secure"
$AgentPassword = Read-Host -AsSecureString -Prompt "Network Agent Password to secure"

if ($KeyFile) {
	$Key = New-Object Byte[] 32 # create key AES 256-bit key (32 bytes)
	[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
	$Key | Out-File $KeyFile

	$EncryptedPass = ConvertFrom-SecureString -SecureString $Password -Key $Key
	$AgentEncryptedPass = ConvertFrom-SecureString -SecureString $AgentPassword -Key $Key
}

Write-Output ""
Write-Output "# Lines to add in your configuration file Custom-VarOverload.psm1"
Write-Output "# or in the auto delete one Custom-VarAutodel.psm1"
Write-Output ""
Write-Output "`$Global:SWMB_Custom.KesSecureString = '$EncryptedPass'"
Write-Output "`$Global:SWMB_Custom.AgentSecureString = '$AgentEncryptedPass'"
Write-Output "`$Global:SWMB_Custom.KesKeyFile      = '$KeyFile'"
Write-Output ""

If (!(Test-Path -LiteralPath ".\Custom-VarAutodel.psm1")) {
	$Query = Read-Host -Prompt "Do you want to create an auto-delete configuration file (Custom-VarAutodel) in the current folder [Y|n]"
	If ($Query.ToLower() -ne "n") {
		Write-Output "
# Configuration for Kaspersky Endpoint
`$Global:SWMB_Custom.KesSecureString = '$EncryptedPass'
`$Global:SWMB_Custom.AgentSecureString = '$AgentEncryptedPass'
`$Global:SWMB_Custom.KesKeyFile      = '$KeyFile'
" | Out-File -FilePath ".\Custom-VarAutodel.psm1" -NoClobber
	}
} ElseIf (Test-Path -LiteralPath ".\Custom-VarOverload.psm1") {
	$Query = Read-Host -Prompt "Do you want to append theses parameters in your current configuration file (Custom-VarOverload) [Y|n]"
	If ($Query.ToLower() -ne "n") {
		Write-Output "
# Configuration for Kaspersky Endpoint
`$Global:SWMB_Custom.KesSecureString = '$EncryptedPass'
`$Global:SWMB_Custom.AgentSecureString = '$AgentEncryptedPass'
`$Global:SWMB_Custom.KesKeyFile      = '$KeyFile'
" | Out-File -FilePath ".\Custom-VarOverload.psm1" -Append
	}
}
