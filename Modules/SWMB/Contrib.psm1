################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2021, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb
# Authors:
#  2020 - Olivier de Marchi (Grenoble INP / LEGI)
#  2020 - David Gras (CNRS / DR11)
#  2020 - Clément Deiber (CNRS / DR11)
#  2020 - Gabriel Moreau (CNRS / LEGI)
################################################################


################################################################
###### User Experience
################################################################

# Computer Configuration / Administrative Templates / Windows Components / News and interests
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.Feeds::EnableFeeds&Language=fr-fr
# https://www.tenforums.com/tutorials/178178-how-enable-disable-news-interests-taskbar-windows-10-a.html
# Disable
Function DisableWindowsFeeds {
	Write-Output "Turn off windows feeds (news and interests)..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Type DWord -Value 0
}

# Enable
Function EnableWindowsFeeds {
	Write-Output "Turn on windows feeds (news and interests)..."
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -ErrorAction SilentlyContinue
}


################################################################
###### Universal Apps
################################################################

## https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.AppPrivacy::LetAppsAccessLocation&Language=fr-fr
# Disable access to location from UWP apps
Function DisableUWPAccessLocation {
	Write-Output "Disabling access to location from UWP apps..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation" -Type DWord -Value 2
}

# Enable access to location from UWP apps
Function EnableUWPAccessLocation {
	Write-Output "Enabling access to location from UWP apps..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation" -ErrorAction SilentlyContinue
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
