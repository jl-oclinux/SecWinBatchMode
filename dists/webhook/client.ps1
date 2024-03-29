#!/usr/bin/env pwsh

$Url='http://localhost:9000/hooks/swmh?token=432&status=logon'
$Payload='{"token": 432, "swmb": {"hostname":"abcmywin", "hostid":"fjjkfhjkj", "osversion": "10.0.45", "username":"toto", "isadmin": false, "version":"3.6.9"}}'

# Invoke-RestMethod -Uri $Url -Body ($Payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json' | Out-File -FilePath ./CurrentUser-Logon-Webhook.preset

$Preset=$(Invoke-RestMethod -Uri $Url -Body "$Payload" -Method Post -ContentType 'application/json')

Write-Output $Preset

# Invoke-RestMethod -Uri $Url -Body "$Payload" -Method Post -ContentType 'application/json' | Out-File -FilePath ./CurrentUser-Logon-Webhook.preset
