################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2023, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
# Authors:
#  2020 - Olivier de Marchi (Grenoble INP / LEGI)
#  2020 - David Gras (CNRS / DR11)
#  2020 - Clément Deiber (CNRS / DR11)
#  2020 - Gabriel Moreau (CNRS / LEGI)
################################################################

################################################################

################################################################

# ClearPageFileAtShutdown
# https://deployadmin.com/2019/11/03/vider-le-fichier-dechange-a-chaque-arret-de-windows/
# Enable
Function TweakEnableClearPageFile { # RESINFO
	Write-Output "Clear PageFile.sys at shutdown..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 1
}

# Disable
Function TweakDisableClearPageFile { # RESINFO
	Write-Output "Do not reset PageFile.sys at shutdown..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
}

# View
Function TweakViewClearPageFile { # RESINFO
	Write-Output 'Clear PageFile.sys (0 nothing enable, 1 clear at shutdown)'
	$KeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
	Get-ItemProperty -Path $KeyPath -Name "ClearPageFileAtShutdown"
}

################################################################

### Automatic clean files - see issues #59 - Storage sense
## https://support.microsoft.com/en-us/windows/manage-drive-space-with-storage-sense-654f6ada-7bfc-45e5-966b-e24aded96ad5
## https://admx.help/HKLM/Software/Policies/Microsoft/Windows/StorageSense

# Allow StorageSense
Function TweakEnableStorageSense { # RESINFO
	Write-Output "Allow Storage sense..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense")) {
		New-Item -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Force | Out-Null
	}
	Set-ItemProperty -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "AllowStorageSenseGlobal" -Type DWord -Value 1
}

# Not Configured:
# By default, Storage Sense is turned off until the user runs into low disk space or the user enables it manually. Users can configure this setting in Storage settings.
Function TweakDisableStorageSense { # RESINFO
	Write-Output "Storage Sense Not Configured"
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -ErrorAction SilentlyContinue
}

# View
Function TweakViewStorageSense { # RESINFO
	Write-Output "View if Storage Sense is turned on for the machine"
	Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "AllowStorageSenseGlobal" -ErrorAction SilentlyContinue
}

# Configure Storage Sense cadence
Function TweakEnableStorageSenseGloablCadence { # RESINFO
	Write-Output "Configure Storage Sense cadence $StorageSenseCadence days"
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense")) {
		New-Item -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Force | Out-Null
	}
	Set-ItemProperty -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "ConfigStorageSenseGlobalCadence" -Type DWord -Value $StorageSenseCadence
}

# Configure Storage Sense cadence
# The default is 0 (during low free disk space)
Function TweakDisableStorageSenseGloablCadence { # RESINFO
	Write-Output "Configure Storage Sense cadence to 0 (during low free disk space)"
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense")) {
		New-Item -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Force | Out-Null
	}
	Set-ItemProperty -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "ConfigStorageSenseGlobalCadence" -Type DWord -Value 0
}

# View
Function TweakViewStorageSenseGloablCadence { # RESINFO
	Write-Output "View Storage Sense cadence"
	Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "ConfigStorageSenseGlobalCadence" -ErrorAction SilentlyContinue
}


################################################################

################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
