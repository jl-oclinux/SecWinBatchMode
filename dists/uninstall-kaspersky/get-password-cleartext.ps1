
Do {
	$KeyFile = Read-Host -Prompt "Key File"
} Until (Test-Path -LiteralPath "$KeyFile")

$EncryptedPass = Read-Host -Prompt "Encrypted blurred Password"

$Password = $EncryptedPass | ConvertTo-SecureString -Key (Get-Content $KeyFile)
$Credential = New-Object System.Management.Automation.PsCredential('AsYouWant',$Password)
$PlainPassword = $Credential.GetNetworkCredential().Password
Write-Output "Password in clear text: $PlainPassword"
