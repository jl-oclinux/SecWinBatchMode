################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2021, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
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
Function TweakDisableWindowsFeeds { # RESINFO
	Write-Output "Turn off windows feeds (news and interests)..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Type DWord -Value 0
}

# Enable
Function TweakEnableWindowsFeeds { # RESINFO
	Write-Output "Turn on windows feeds (news and interests)..."
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -ErrorAction SilentlyContinue
}

################################################################

# https://www.commentcamarche.net/informatique/windows/29-activer-le-god-mode-mode-dieu-de-windows-10/
# Enable
Function TweakEnableGodMod_CU { # RESINFO
	Write-Output "Enable GodMod on current user desktop..."
	$DesktopPath = [Environment]::GetFolderPath("Desktop");
	New-Item -Path  "$DesktopPath\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" -Type Directory
}

# Disable
Function TweakDisableGodMod_CU { # RESINFO
	Write-Output "Disable GodMod from current user desktop..."
	$DesktopPath = [Environment]::GetFolderPath("Desktop");
	Remove-Item -Path  "$DesktopPath\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" -Recurse -ErrorAction SilentlyContinue
}


################################################################
###### Universal Apps
################################################################

## https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.AppPrivacy::LetAppsAccessLocation&Language=fr-fr
# Disable access to location from UWP apps
Function TweakDisableUWPAccessLocation { # RESINFO
	Write-Output "Disabling access to location from UWP apps..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation" -Type DWord -Value 2
}

# Enable access to location from UWP apps
Function TweakEnableUWPAccessLocation { # RESINFO
	Write-Output "Enabling access to location from UWP apps..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation" -ErrorAction SilentlyContinue
}


################################################################
###### Network Tweaks
################################################################

# Disable obsolete SMB 1.0 protocol - Disabled by default since 1709
Function TweakDisableSMB1Protocol { # RESINFO
	Write-Output "Disabling SMB 1.0 protocol..."
	Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -Norestart
}

# Enable obsolete SMB 1.0 protocol - Disabled by default since 1709
Function TweakEnableSMB1Protocol { # RESINFO
	Write-Output "Enabling SMB 1.0 protocol..."
	Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -Norestart
}


################################################################
##### Server Specific
################################################################

# https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.LanmanWorkstation::Pol_EnableInsecureGuestLogons
# https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-workstationservice-allowinsecureguestauth
# Enable
Function TweakEnableInsecureGuestLogons { # RESINFO
	Write-Output "SMB client will allow insecure guest logons to an SMB server"
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\LanmanWorkstation")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\LanmanWorkstation" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\LanmanWorkstation" -Name "AllowInsecureGuestAuth" -Value 1
}

# Disable (default)
Function TweakDisableInsecureGuestLogons { # RESINFO
	Write-Output "SMB client rejects insecure guest logons to an SMB server (default)"
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\LanmanWorkstation" -Name "AllowInsecureGuestAuth" -ErrorAction SilentlyContinue
}


################################################################
##### Service Tweaks
################################################################


# Disable offering of drivers through network
# Is part of DisableUpdateDriver
Function TweakDisableAutoloadDriver { # RESINFO
	Write-Output "Disabling autoload driver from network..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value 1
}

# Enable offering of drivers through network
Function TweakEnableAutoloadDriver { # RESINFO
	Write-Output "Enabling autoload driver from network..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -ErrorAction SilentlyContinue
}

# View
Function TweakViewAutoloadDriver { # RESINFO
	Write-Output 'Autoload driver from network (0 no or not exist - enable, 1 disable)'
	Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Name "PreventDeviceMetadataFromNetwork"
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
