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
	Write-Output "Allow Storage sense...and Configure Storage Sense cadence $($Global:SWMB_Custom.StorageSenseCadence) day"
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense")) {
		New-Item -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Force | Out-Null
	}
	Set-ItemProperty -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "AllowStorageSenseGlobal" -Type DWord -Value 1
	Set-ItemProperty -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "ConfigStorageSenseGlobalCadence" -Type DWord -Value $Global:SWMB_Custom.StorageSenseCadence
}

# Not Configured:
# By default, Storage Sense is turned off until the user runs into low disk space or the user enables it manually. Users can configure this setting in Storage settings.
Function TweakDisableStorageSense { # RESINFO
	Write-Output "Storage Sense Not Configured"
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -ErrorAction SilentlyContinue
}

# View
Function TweakViewStorageSense { # RESINFO
	Write-Output "View if Storage Sense is turned on for the machine"
	Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "AllowStorageSenseGlobal" -ErrorAction SilentlyContinue
	Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "ConfigStorageSenseGlobalCadence" -ErrorAction SilentlyContinue
}

# Allow storage sense tempory files Cleanup
# Storage Sense will delete the user's temporary files that are not in use. Users cannot disable this setting in Storage settings.
Function TweakEnableStorageSenseTemporaryFilesCleanup { # RESINFO
	Write-Output "Allow Storage sense Temporary Files Cleanup"
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense")) {
		New-Item -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Force | Out-Null
	}
	Set-ItemProperty -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "AllowStorageSenseTemporaryFilesCleanup" -Type DWord -Value 1
}

# Disabled:
# Storage Sense will not delete the user's temporary files. Users cannot enable this setting in Storage settings.
Function TweakDisableStorageSenseTemporaryFilesCleanup { # RESINFO
	Write-Output "Disable Storage sense Temporary Files Cleanup"
	Set-ItemProperty -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "AllowStorageSenseTemporaryFilesCleanup" -Type DWord -Value 0
}

# View
Function TweakViewStorageSenseTemporaryFilesCleanup { # RESINFO
	Write-Output "View if Storage Sense Temporary Files Cleanup is turned on"
	Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "AllowStorageSenseTemporaryFilesCleanup" -ErrorAction SilentlyContinue
}


################################################################

################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
