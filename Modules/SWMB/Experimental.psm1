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

################################################################

# Allow storage sense tempory files Cleanup
# Storage Sense will delete the user's temporary files that are not in use. Users cannot disable this setting in Storage settings.
Function TweakEnableStorageSenseTempCleanup { # RESINFO
	Write-Output "Allow Storage sense Temporary Files Cleanup"
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense")) {
		New-Item -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Force | Out-Null
	}
	Set-ItemProperty -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "AllowStorageSenseTemporaryFilesCleanup" -Type DWord -Value 1
}

# Disabled:
# Storage Sense will not delete the user's temporary files. Users cannot enable this setting in Storage settings.
Function TweakDisableStorageSenseTempCleanup { # RESINFO
	Write-Output "Disable Storage sense Temporary Files Cleanup"
	Set-ItemProperty -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "AllowStorageSenseTemporaryFilesCleanup" -Type DWord -Value 0
}

# View
Function TweakViewStorageSenseTempCleanup { # RESINFO
	Write-Output "View if Storage Sense Temporary Files Cleanup is turned on"
	Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "AllowStorageSenseTemporaryFilesCleanup" -ErrorAction SilentlyContinue
}

################################################################

# Configure Storage Sense Recycle Bin cleanup threshold
# minimum age threshold (in days) of a file in the Recycle Bin before Storage Sense will delete it
Function TweakEnableStorageSenseTrashCleanup { # RESINFO
	Write-Output "Files in the recycle bin that are more than $($Global:SWMB_Custom.StorageSenseTrashCleanup) days old will be deleted automatically"
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense")) {
		New-Item -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Force | Out-Null
	}
	Set-ItemProperty -Path  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "ConfigStorageSenseRecycleBinCleanupThreshold" -Type DWord -Value $Global:SWMB_Custom.StorageSenseTrashCleanup
}

# Disabled:
# By default, Storage Sense will delete files in the user's Recycle Bin that have been there for over 30 days.
Function TweakDisableStorageSenseTrashCleanup { # RESINFO
	Write-Output "Disable Storage sense Temporary Files Cleanup"
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "ConfigStorageSenseRecycleBinCleanupThreshold" -ErrorAction SilentlyContinue
}

# View
Function TweakViewStorageSenseTrashCleanup { # RESINFO
	Write-Output "View Storage Sense Bin automatically Cleanup"
	Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "ConfigStorageSenseRecycleBinCleanupThreshold" -ErrorAction SilentlyContinue
}

################################################################

# Force reboot now if pending reboot
# Adapted from https://gist.github.com/altrive/5329377
# Based on <https://gallery.technet.microsoft.com/scriptcenter/Get-PendingReboot-Query-bdb79542>
# https://www.geekbits.io/how-to-view-a-pending-reboot-in-windows/
# https://stackoverflow.com/questions/47867949/how-can-i-check-for-a-pending-reboot
	Function _TestPendingReboot {
		# Check for 'Reboot Required' registry key 
		If (Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue) { Return $True }

		# Check for 'Reboot Required' registry key 
		If (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue) { Return $True }

	#	# Check for recent installation requiring reboot
	#	If (Test-Path "HKLM:\SOFTWARE\Microsoft\Updates\UpdateExeVolatile" -ErrorAction SilentlyContinue) { Return $True }

		# Check for System Center Configuration Manager 
		If (Test-Path "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData" -ErrorAction SilentlyContinue) { Return $True }

	#	#Check for PendingFileRenameOperations
	#	If (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name 'PendingFileRenameOperations' -ErrorAction SilentlyContinue) { Return $True }

	#	Try { 
	#		$Util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
	#		$Status = $Util.DetermineIfRebootPending()
	#		if(($Status -ne $Null) -and $Status.RebootPending){
	#			return $True
	#		}
	#	} Catch {}

		Return $False
	}

# View
Function TweakViewPendingReboot { # RESINFO
	If (_TestPendingReboot) {
		Write-Output "View PendingReboot: reboot is needed"
	} Else {
		Write-Output "View PendingReboot: no reboot in queue"
	}
}

# Set
Function TweakSetPendingReboot { # RESINFO
	If (_TestPendingReboot) {
		Write-Output "PendingReboot: reboot computer now..."
		Restart-Computer
	} Else {
		Write-Output "View PendingReboot: no reboot in queue"
	}
}

################################################################

################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function Tweak*
