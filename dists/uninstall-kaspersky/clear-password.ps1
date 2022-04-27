
$KeyFile = Read-Host -Prompt "Key File"
$BlurPassword = Read-Host -Prompt "Blur Password"

$Password = $BlurPassword | ConvertTo-SecureString -Key (Get-Content $KeyFile)
$Credential = New-Object System.Management.Automation.PsCredential('AsYouWant',$Password)
$PlainPassword = $Credential.GetNetworkCredential().Password
Write-Output $PlainPassword
