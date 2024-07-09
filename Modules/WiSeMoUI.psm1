################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2024, CNRS, France
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
	$InstallFolder = (Join-Path -Path ${Env:ProgramFiles} -ChildPath "SWMB")
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

Function SWMB_GetHomeURL {
	Return 'https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb'
}

################################################################

Function SWMB_GetDownloadURL {
	Return 'https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb'
}

################################################################

Function SWMB_GetHostId {
	Return (Get-ItemProperty -Path 'HKLM:\Software\WOW6432Node\SWMB' -Name 'HostId' -ErrorAction SilentlyContinue).HostId
}

################################################################

Function SWMB_GetLastPublishedVersion {
	$Url = (SWMB_GetDownloadURL)
	[System.Net.ServicePointManager]::MaxServicePointIdleTime = 3000
	Try {
		$NextVersion = ((Invoke-WebRequest -Uri "$Url/version.txt" -Method Get -TimeoutSec 3).Content)
	} Catch {
		$NextVersion = ""
	}
	Return $NextVersion
}

################################################################
# ProtectionStatus
#   On
#   Off
# VolumeStatus
#   FullyDecrypted
#   FullyEncrypted
#   EncryptionInProgress
#   DecryptionInProgress
# EncryptionMethod
#   XtsAes256
#   XtsAes128

Function SWMB_GetBitLockerStatus {
	Param (
		[Parameter(Mandatory = $True)] [string]$Drive
	)

	#$DriveLetter  = $Drive.Substring(0, 1)
	$DrivePStatus = (Get-BitLockerVolume $Drive).ProtectionStatus
	$DriveVStatus = (Get-BitLockerVolume $Drive).VolumeStatus
	$DriveEMethod = (Get-BitLockerVolume $Drive).EncryptionMethod

	If (($DrivePStatus -eq "On") -or ($DriveVStatus -eq "EncryptionInProgress")) {
		Return "Running / $DriveEMethod"
	}
	If (($DrivePStatus -eq "Off") -or ($DriveVStatus -eq "FullyEncrypted")) {
		Return "Suspend / $DriveEMethod"
	}
	If (($DrivePStatus -eq "Off") -or ($DriveVStatus -eq "FullyDecrypted")) {
		Return "NotConfigured"
	}
	Return "$DrivePStatus / $DriveVStatus / $DriveEMethod"
}

################################################################

# Return OS version in a readable format
Function SWMB_GetOSVersionReadable {
  $OSVersion = SWMB_GetOSVersion
  $DisplayVersion = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name DisplayVersion).DisplayVersion
  $UBR = $OSVersion.Revision
  If ($OSVersion -ge [version]"10.0.22000.0") {
    $Text = "Windows 11 / $DisplayVersion.$UBR"
  } ElseIf ($OSVersion -ge [version]"10.0.10240.0") {
    $Text = "Windows 10 / $DisplayVersion.$UBR"
  } Else {
    $Text = "Windows version unknown"
  }
  Return $Text
}

################################################################

# Return OS version in a readable format
Function SWMB_GetOSVersionColor {
  $OSVersion = SWMB_GetOSVersion
  $Build = $OSVersion.Build
  $UBR = $OSVersion.Revision

  # Last OS revision
  $UBR10 = 4529
  $UBR11 = 2211

  $Color = "Red"
  If ($OSVersion -ge [version]"10.0.22000.0") {
    # Windows 11
    If ($OSVersion -ge [version]"10.0.22631.$UBR11") {
      $Color = "Green"
      }
  } ElseIf ($OSVersion -ge [version]"10.0.10240.0") {
    # Windows 10
    If ($OSVersion -ge [version]"10.0.19045.$UBR10") {
      $Color = "Green"
      }
  }
  Return $Color
}

################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function SWMB_*
