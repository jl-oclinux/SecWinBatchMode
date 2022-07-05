################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2022, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
# Authors:
#  2020 - Olivier de Marchi (Grenoble INP / LEGI)
#  2020 - Clément Deiber (CNRS / DR11)
#  2020 - Gabriel Moreau (CNRS / LEGI)
################################################################

################################################################
###### Software Uninstall
################################################################

################################################################

# With the help of https://silentinstallhq.com/winrar-silent-uninstall-powershell/

Function TweakUninstallRealPlayer { # RESINFO
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | 
		Where { $_.Name  -match 'RealPlayer \d' } |
		ForEach {
			$Key = (Get-ItemProperty -Path $_.PSPath)
			$VersionMajor = $Key.VersionMajor
			$VersionMinor = $Key.VersionMinor
			$UninstallString = $Key.UninstallString
			$UninstallSplit = $UninstallString -Split "exe"
			$Exe = $UninstallSplit[0] + 'exe'
			$Args = '"' + $UninstallSplit[1].Trim() + '"' + ' -s'
			If (Test-Path -Path "$Exe") {
				Write-Output "Uninstalling Any Existing Versions of RealPlayer $VersionMajor.$VersionMinor"
				Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -Wait -ErrorAction 'SilentlyContinue'
			}
			Start-Sleep -s 2
		}

	## Uninstall RealTimes Desktop Service
	If (Test-Path -Path "$Env:ProgramFiles\Real\RealPlayer\RPDS\uninst.exe") {
		Write-Output "Uninstalling RealTimes Desktop Service."
		Start-Process -FilePath "$Env:ProgramFiles\Real\RealPlayer\RPDS\uninst.exe" -ArgumentList "-s" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
		Start-Sleep -s 6
	}
	If (Test-Path -Path "${Env:ProgramFiles(x86)}\Real\RealPlayer\RPDS\uninst.exe") {
		Write-Output "Uninstalling RealTimes Desktop Service."
		Start-Process -FilePath "${Env:ProgramFiles(x86)}\Real\RealPlayer\RPDS\uninst.exe" -ArgumentList "-s" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
		Start-Sleep -s 6
	}
	## Uninstall RealUpgrade
	If (Test-Path -Path "$Env:ProgramFiles\Real\RealUpgrade\uninst.exe") {
		Write-Output "Uninstalling Any Existing Versions of RealUpgrade."
		Start-Process -FilePath "$Env:ProgramFiles\Real\RealUpgrade\uninst.exe" -ArgumentList "-s" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
		Start-Sleep -s 6
	}
	If (Test-Path -Path "${Env:ProgramFiles(x86)}\Real\RealUpgrade\uninst.exe") {
		Write-Output "Uninstalling Any Existing Versions of RealUpgrade."
		Start-Process -FilePath "${Env:ProgramFiles(x86)}\Real\RealUpgrade\uninst.exe" -ArgumentList "-s" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
		Start-Sleep -s 6
	}
	## Cleanup Start Menu Directory
	If (Test-Path -Path "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Real\RealPlayer*.lnk") {
		Write-Output "Removing Existing RealPlayer Start Menu Entry."
		Remove-Item -Path "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Real\RealPlayer*.lnk" -Force -ErrorAction SilentlyContinue
		Sleep -Seconds 2 
	}
	## Cleanup ProgramData Directory
	If (Test-Path -Path "$Env:ALLUSERSPROFILE\Real\") {
		Write-Output "Removing Existing Real ProgramData Directory."
		Remove-Item -Path "$Env:ALLUSERSPROFILE\Real\" -Force -Recurse -ErrorAction SilentlyContinue
		Sleep -Seconds 2
	}
	## Cleanup RealPlayer Directories
	If (Test-Path -Path "$Env:ProgramFiles\Real\") {
		Write-Output "Cleanup $Env:ProgramFiles\Real\ Directory."
		Remove-Item -Path "$Env:ProgramFiles\Real\" -Force -Recurse -ErrorAction SilentlyContinue 
		Sleep -Seconds 2
	}
	If (Test-Path -Path "${Env:ProgramFiles(x86)}\Real\") {
		Write-Output "Cleanup $Env:ProgramFiles\Real\ Directory."
		Remove-Item -Path "${Env:ProgramFiles(x86)}\Real\" -Force -Recurse -ErrorAction SilentlyContinue 
		Sleep -Seconds 2
	}
	## Cleanup Local & Roaming RealPlayer Directories
	Get-WmiObject -ClassName Win32_UserProfile | Where {!$_.Special} | Select LocalPath | ForEach {
		$UserPath = $_
		ForEach ($UserCleanDir in "$UserPath\AppData\Local\Real", "$UserPath\AppData\Roaming\Real") {
			If (Test-Path $UserCleanDir) {
				Write-Output "Cleanup ($UserCleanDir) Directory."
				Remove-Item -Path "$UserCleanDir" -Force -Recurse -ErrorAction SilentlyContinue
			}
		}
	}
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function Tweak*
