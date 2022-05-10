
$KesKeyFile = Read-Host -Prompt "Key File (please put .key extension, empty if pass in clear text)"
$KesEndpointPassword = Read-Host -AsSecureString -Prompt "Kaspersky Endpoint Password to secure"
$KesAgentPassword    = Read-Host -AsSecureString -Prompt "Kaspersky Network Agent Password to secure"


If ($KesKeyFile) {
	If (Test-Path -LiteralPath "$KesKeyFile") {
		# Use the same last key
		$Key = (Get-Content $KesKeyFile)
	} Else {
		# Create a new key
		$Key = New-Object Byte[] 32 # create key AES 256-bit key (32 bytes)
		[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
		$Key | Out-File $KesKeyFile
	}

	If ($KesEndpointPassword.Length -ne 0) {$KesEndpointSecureString = ConvertFrom-SecureString -SecureString $KesEndpointPassword -Key $Key}
	If ($KesAgentPassword.Length    -ne 0) {$KesAgentSecureString    = ConvertFrom-SecureString -SecureString $KesAgentPassword    -Key $Key}
} Else {
	# Default values if no key file
	$KesEndpointSecureString = ConvertFrom-SecureString -SecureString $KesEndpointPassword -AsPlainText
	$KesAgentSecureString    = ConvertFrom-SecureString -SecureString $KesAgentPassword    -AsPlainText
}

Write-Output ""
Write-Output "# Lines to add in your configuration file Custom-VarOverload.psm1"
Write-Output "# or in the auto delete one Custom-VarAutodel.psm1"
Write-Output ""
Write-Output "# Configuration for Kaspersky Endpoint and Network Agent"
Write-Output "`$Global:SWMB_Custom.KesPassword  = '$KesEndpointSecureString'"
Write-Output "`$Global:SWMB_Custom.KesAgentPass = '$KesAgentSecureString'"
Write-Output "`$Global:SWMB_Custom.KesKeyFile   = '$KesKeyFile'"
Write-Output ""

If (!(Test-Path -LiteralPath ".\Custom-VarAutodel.psm1")) {
	$Query = Read-Host -Prompt "Do you want to create an auto-delete configuration file (Custom-VarAutodel) in the current folder [Y|n]"
	If ($Query.ToLower() -ne "n") {
		Write-Output "
# Configuration for Kaspersky Endpoint and Network Agent
`$Global:SWMB_Custom.KesPassword  = '$KesEndpointSecureString'
`$Global:SWMB_Custom.KesAgentPass = '$KesAgentSecureString'
`$Global:SWMB_Custom.KesKeyFile   = '$KesKeyFile'
" | Out-File -FilePath ".\Custom-VarAutodel.psm1" -NoClobber
	}
} ElseIf (Test-Path -LiteralPath ".\Custom-VarOverload.psm1") {
	$Query = Read-Host -Prompt "Do you want to append theses parameters in your current configuration file (Custom-VarOverload) [Y|n]"
	If ($Query.ToLower() -ne "n") {
		Write-Output "
# Configuration for Kaspersky Endpointand Network Agent
`$Global:SWMB_Custom.KesPassword  = '$KesEndpointSecureString'
`$Global:SWMB_Custom.KesAgentPass = '$KesAgentSecureString
`$Global:SWMB_Custom.KesKeyFile   = '$KesKeyFile'
" | Out-File -FilePath ".\Custom-VarOverload.psm1" -Append
	}
}
