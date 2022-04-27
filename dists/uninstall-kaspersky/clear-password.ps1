
$KeyFile = Read-Host -Prompt "Key File"
$SecureString = Read-Host -Prompt "Blur Password"

$Password = ConvertTo-SecureString -Key (Get-Content $KeyFile) $SecureString
Write-Output $Password
