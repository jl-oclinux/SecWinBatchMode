
Do {
	$KeyFile = Read-Host -Prompt "Key File"
} Until (Test-Path -LiteralPath "$KeyFile")

$EndpointEncryptedPass = Read-Host -Prompt "Encrypted blurred Endpoint Password"
$AgentEncryptedPass    = Read-Host -Prompt "Encrypted blurred Agent Password"

$EndpointPassword   = $EndpointEncryptedPass | ConvertTo-SecureString -Key (Get-Content $KeyFile)
$EndpointCredential = New-Object System.Management.Automation.PsCredential('AsYouWant',$EndpointPassword)
$EndpointPlainPassword = $EndpointCredential.GetNetworkCredential().Password
Write-Output "Endpoint Password in clear text: $EndpointPlainPassword"

$AgentPassword   = $AgentEncryptedPass | ConvertTo-SecureString -Key (Get-Content $KeyFile)
$AgentCredential = New-Object System.Management.Automation.PsCredential('AsYouWant',$AgentPassword)
$AgentPlainPassword = $AgentCredential.GetNetworkCredential().Password
Write-Output "Agent Password in clear text: $AgentPlainPassword"
