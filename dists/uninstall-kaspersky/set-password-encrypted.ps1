
$KesKeyFile = Read-Host -Prompt "Key File (please put .key extension)"
$KesPassword = Read-Host -AsSecureString -Prompt "Password to secure"
$KesAgentPassword = Read-Host -AsSecureString -Prompt "Network Agent Password to secure"

if ($KesKeyFile) {
	$Key = New-Object Byte[] 32 # create key AES 256-bit key (32 bytes)
	[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
	$Key | Out-File $KesKeyFile

	$KesSecureString = ConvertFrom-SecureString -SecureString $KesPassword -Key $Key
	$KesAgentSecureString = ConvertFrom-SecureString -SecureString $KesAgentPassword -Key $Key
}

Write-Output ""
Write-Output "# Lines to add in your configuration file Custom-VarOverload.psm1"
Write-Output "# or in the auto delete one Custom-VarAutodel.psm1"
Write-Output ""
Write-Output "`$Global:SWMB_Custom.KesSecureString = '$KesSecureString'"
Write-Output "`$Global:SWMB_Custom.KesAgentSecureString = '$KesAgentSecureString'"
Write-Output "`$Global:SWMB_Custom.KesKeyFile      = '$KesKeyFile'"
Write-Output ""

If (!(Test-Path -LiteralPath ".\Custom-VarAutodel.psm1")) {
	$Query = Read-Host -Prompt "Do you want to create an auto-delete configuration file (Custom-VarAutodel) in the current folder [Y|n]"
	If ($Query.ToLower() -ne "n") {
		Write-Output "
# Configuration for Kaspersky Endpoint
`$Global:SWMB_Custom.KesSecureString = '$KesSecureString'
`$Global:SWMB_Custom.KesAgentSecureString = '$KesAgentSecureString'
`$Global:SWMB_Custom.KesKeyFile      = '$KesKeyFile'
" | Out-File -FilePath ".\Custom-VarAutodel.psm1" -NoClobber
	}
} ElseIf (Test-Path -LiteralPath ".\Custom-VarOverload.psm1") {
	$Query = Read-Host -Prompt "Do you want to append theses parameters in your current configuration file (Custom-VarOverload) [Y|n]"
	If ($Query.ToLower() -ne "n") {
		Write-Output "
# Configuration for Kaspersky Endpoint
`$Global:SWMB_Custom.KesSecureString = '$KesSecureString'
`$Global:SWMB_Custom.KesAgentSecureString = '$KesAgentSecureString
`$Global:SWMB_Custom.KesKeyFile      = '$KesKeyFile'
" | Out-File -FilePath ".\Custom-VarOverload.psm1" -Append
	}
}
