
Do {
	$KeyFile = Read-Host -Prompt "Key File"
} Until (Test-Path -LiteralPath "$KeyFile")

$EncryptedEndpointPass = Read-Host -Prompt "Encrypted blurred Endpoint Password"
$EncryptedAgentPass    = Read-Host -Prompt "Encrypted blurred Agent Password"

$EndpointPassword   = $EncryptedEndpointPass | ConvertTo-SecureString -Key (Get-Content $KeyFile)
$EndpointCredential = New-Object System.Management.Automation.PsCredential('AsYouWant',$EndpointPassword)
$EndpointPlainPassword = $EndpointCredential.GetNetworkCredential().Password
Write-Output "Endpoint Password in clear text: $EndpointPlainPassword"

$AgentPassword   = $EncryptedAgentPass | ConvertTo-SecureString -Key (Get-Content $KeyFile)
$AgentCredential = New-Object System.Management.Automation.PsCredential('AsYouWant',$AgentPassword)
$AgentPlainPassword = $AgentCredential.GetNetworkCredential().Password
Write-Output "Agent Password in clear text: $AgentPlainPassword"
