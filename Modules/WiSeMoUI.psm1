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

Function SWMB_GetInstallFolder {
	$InstallFolder = (Join-Path -Path $Env:ProgramFiles -ChildPath "SWMB")
	If (Test-Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SWMB") {
		$InstallFolder = (Get-ItemProperty -Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SWMB" -Name "InstallFolder").InstallFolder
	}
	Return $InstallFolder
}

################################################################

Function SWMB_GetRunningVersion {
	$InstallFolder = (SWMB_GetInstallFolder)
	$VersionModule = (Join-Path -Path "$InstallFolder" -ChildPath (Join-Path -Path "Modules" (Join-Path -Path "SWMB" -ChildPath "Version.psd1")))
	$Version = ''
	If (Test-Path $VersionModule) {
		Import-Module -Name $VersionModule -ErrorAction Stop
		$Version = (Get-Module -Name Version).Version.ToString()
	}
	Return $Version
}

################################################################

Function SWMB_GetLastPublishedVersion {
	$Url = 'https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb'
	[System.Net.ServicePointManager]::MaxServicePointIdleTime = 3000
	Try {
		$NextVersion = ((Invoke-WebRequest -Uri "$Url/version.txt" -Method Get -TimeoutSec 3).Content)
	} Catch {
		$NextVersion = ""
	}
	Return $NextVersion
}

################################################################

Function SWMB_GetBitLockerStatus {
	$SystemDrive       = $Env:SystemDrive
	$SystemDriveLetter = $systemDrive.Substring(0, 1)
	$SytemDrivePStatus = (Get-BitLockerVolume $SystemDrive).ProtectionStatus
	$SytemDriveVStatus = (Get-BitLockerVolume $SystemDrive).VolumeStatus

	If (($SytemDrivePStatus -eq "On") -or ($SytemDriveVStatus -eq "EncryptionInProgress")) {
		Return "Runnning"
	}
	If (($SytemDrivePStatus -eq "Off") -or ($SytemDriveVStatus -eq "FullyDecrypted")) {
		Return "Not Configured"
	}
	Return "$SytemDrivePStatus/$SytemDriveVStatus"
}

################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
