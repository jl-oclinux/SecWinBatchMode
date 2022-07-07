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
# With the help of https://silentinstallhq.com/realplayer-silent-install-how-to-guide/

Function TweakUninstallRealPlayer { # RESINFO
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | 
		Where { $_.Name -match 'RealPlayer \d' } |
		ForEach {
			$App = (Get-ItemProperty -Path $_.PSPath)
			$VersionMajor = $App.VersionMajor
			$VersionMinor = $App.VersionMinor
			$UninstallString = $App.UninstallString

			# Kill process
			ForEach ($Task in 'RealPlayerUpdateSvc.exe', 'realsched.exe', 'rpbgdownloader.exe', 'rpsystray.exe', 'rpdsvc.exe') {
				Get-Process -Name "$Task" -ErrorAction 'SilentlyContinue' | Stop-Process -Force -ErrorAction 'SilentlyContinue'
			}

			$UninstallSplit = $UninstallString -Split "exe"
			$Exe = $UninstallSplit[0] + 'exe'
			$Args = '"' + $UninstallSplit[1].Trim() + '"' + ' -s'
			If (Test-Path -Path "$Exe") {
				Write-Output "Uninstalling RealPlayer version $VersionMajor.$VersionMinor"
				$Proc = Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

				$Timeouted = $Null # Reset any previously set timeout
				# Wait up to 180 seconds for normal termination
				$Proc | Wait-Process -Timeout 300 -ErrorAction SilentlyContinue -ErrorVariable Timeouted
				if ($Timeouted) {
					# Terminate the process
					$Proc | Kill
					Write-Output "Error: kill RealPlayer uninstall exe"
					# Next tweak now
					Return
				} ElseIf ($Proc.ExitCode -ne 0) {
					Write-Output "Error: RealPlayer uninstall return code $Proc.ExitCode"
					# Next tweak now
					Return
				}
			}
			Start-Sleep -Seconds 2
		}

	## Uninstall RealTimes Desktop Service
	If (Test-Path -Path "$Env:ProgramFiles\Real\RealPlayer\RPDS\uninst.exe") {
		Write-Output "Uninstalling RealTimes Desktop Service."
		Start-Process -FilePath "$Env:ProgramFiles\Real\RealPlayer\RPDS\uninst.exe" -ArgumentList "-s" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -Wait
		Start-Sleep -Seconds 2
	}
	If (Test-Path -Path "${Env:ProgramFiles(x86)}\Real\RealPlayer\RPDS\uninst.exe") {
		Write-Output "Uninstalling RealTimes Desktop Service."
		Start-Process -FilePath "${Env:ProgramFiles(x86)}\Real\RealPlayer\RPDS\uninst.exe" -ArgumentList "-s" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -Wait
		Start-Sleep -Seconds 2
	}
	## Uninstall RealUpgrade
	If (Test-Path -Path "$Env:ProgramFiles\Real\RealUpgrade\uninst.exe") {
		Write-Output "Uninstalling Any Existing Versions of RealUpgrade."
		Start-Process -FilePath "$Env:ProgramFiles\Real\RealUpgrade\uninst.exe" -ArgumentList "-s" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -Wait
		Start-Sleep -Seconds 2
	}
	If (Test-Path -Path "${Env:ProgramFiles(x86)}\Real\RealUpgrade\uninst.exe") {
		Write-Output "Uninstalling Any Existing Versions of RealUpgrade."
		Start-Process -FilePath "${Env:ProgramFiles(x86)}\Real\RealUpgrade\uninst.exe" -ArgumentList "-s" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -Wait
		Start-Sleep -Seconds 2
	}
	## Cleanup Start Menu Directory
	If (Test-Path -Path "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Real\") {
		Write-Output "Removing RealPlayer Start Menu Entry."
		Remove-Item -Path "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Real\" -Force -Recurse -ErrorAction SilentlyContinue
		Start-Sleep -Seconds  2 
	}
	## Cleanup ProgramData Directory
	If (Test-Path -Path "$Env:ALLUSERSPROFILE\Real\") {
		Write-Output "Removing Existing Real ProgramData Directory."
		Remove-Item -Path "$Env:ALLUSERSPROFILE\Real\" -Force -Recurse -ErrorAction SilentlyContinue
		Start-Sleep -Seconds  1
	}
	## Cleanup RealPlayer Directories
	If (Test-Path -Path "$Env:ProgramFiles\Real\") {
		Write-Output "Cleanup $Env:ProgramFiles\Real\ Directory."
		Remove-Item -Path "$Env:ProgramFiles\Real\" -Force -Recurse -ErrorAction SilentlyContinue 
		Start-Sleep -Seconds  1
	}
	If (Test-Path -Path "${Env:ProgramFiles(x86)}\Real\") {
		Write-Output "Cleanup ${Env:ProgramFiles(x86)}\Real\ Directory."
		Remove-Item -Path "${Env:ProgramFiles(x86)}\Real\" -Force -Recurse -ErrorAction SilentlyContinue 
		Start-Sleep -Seconds  1
	}
	## Cleanup Local & Roaming RealPlayer Directories
	Get-WmiObject -ClassName Win32_UserProfile | Where {!$_.Special} | Select LocalPath | ForEach {
		$UserHomePath = $_
		ForEach ($UserCleanItem in "$UserHomePath\AppData\Local\Real", "$UserHomePath\AppData\Roaming\Real") {
			If (Test-Path -Path "$UserCleanItem") {
				Write-Output "Cleanup ($UserCleanItem) Directory."
				Remove-Item -Path "$UserCleanItem" -Force -Recurse -ErrorAction SilentlyContinue
			}
		}
	}
}

################################################################
# With the help of https://silentinstallhq.com/winrar-silent-uninstall-powershell/

Function TweakUninstallWinRAR { # RESINFO
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | 
		Where { $_.Name -match 'WinRAR archiver' } |
		ForEach {
			$App = (Get-ItemProperty -Path $_.PSPath)
			$VersionMajor = $App.VersionMajor
			$VersionMinor = $App.VersionMinor
			$Exe = $App.UninstallString
			$Args = '/S'
			If (Test-Path -Path "$Exe") {
				Write-Output "Uninstalling WinRAR version $VersionMajor.$VersionMinor"
				$Proc = Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

				$Timeouted = $Null # Reset any previously set timeout
				# Wait up to 180 seconds for normal termination
				$Proc | Wait-Process -Timeout 300 -ErrorAction SilentlyContinue -ErrorVariable Timeouted
				if ($Timeouted) {
					# Terminate the process
					$Proc | Kill
					Write-Output "Error: kill WinRAR uninstall exe"
					# Next tweak now
					Return
				} ElseIf ($Proc.ExitCode -ne 0) {
					Write-Output "Error: WinRAR uninstall return code $Proc.ExitCode"
					# Next tweak now
					Return
				}
			}
			Start-Sleep -Seconds 2
		}

	## Cleanup Start Menu Directory
	If (Test-Path -Path "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\WinRAR\") {
		Write-Output "Removing WinRAR Start Menu Entry."
		Remove-Item -Path "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\WinRAR\" -Force -Recurse -ErrorAction SilentlyContinue
		Start-Sleep -Seconds  2 
	}

	## Cleanup User Profile (If Present)
	Get-WmiObject -ClassName Win32_UserProfile | Where {!$_.Special} | Select LocalPath | ForEach {
		$UserHomePath = $_
		ForEach ($UserCleanItem in "$UserHomePath\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\WinRAR") {
			If (Test-Path -Path "$UserCleanItem") {
				Write-Output "Cleanup ($UserCleanItem) Directory."
				Remove-Item -Path "$UserCleanItem" -Force -Recurse -ErrorAction SilentlyContinue
			}
		}
	}
}

################################################################
# https://silentinstallhq.com/avast-free-antivirus-silent-install-how-to-guide/
# Does not work - impossible to change the Stats.ini file
Function TweakUninstallAvast { # RESINFO
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | 
		Where { $_.Name -match 'Avast Antivirus' } |
		ForEach {
			$App = (Get-ItemProperty -Path $_.PSPath)
			$VersionMajor = $App.VersionMajor
			$VersionMinor = $App.VersionMinor
			$UninstallString = $App.UninstallString
			$InstallLocation = $App.InstallLocation

			$UninstallSplit = $UninstallString -Split "exe"
			$Exe = $UninstallSplit[0] + 'exe'
			$Args = '"' + $UninstallSplit[1].Trim() + '"' + ' /instop:uninstall /silent /wait'
			If (Test-Path -Path "$Exe") {
				# Need to be changed for silent uninstall
				$StatsIni = "$InstallLocation\setup\Stats.ini"
				If (Test-Path -Path "$StatsIni") {
					(Get-Content $StatsIni) | ForEach-Object { $_ -replace "\[Common\]", "[Common]`nSilentUninstallEnabled=1" } | Set-Content $StatsIni
				}

				Write-Output "Uninstalling Avast Antivirus version $VersionMajor.$VersionMinor"
				# Ok but UI (without UI if SYSTEM account)
				$Proc = Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

				$Timeouted = $Null # Reset any previously set timeout
				# Wait up to 180 seconds for normal termination
				$Proc | Wait-Process -Timeout 300 -ErrorAction SilentlyContinue -ErrorVariable Timeouted
				if ($Timeouted) {
					# Terminate the process
					$Proc | Kill
					Write-Output "Error: kill Avast uninstall exe"
					# Next tweak now
					Return
				} ElseIf ($Proc.ExitCode -ne 0) {
					Write-Output "Error: Avast uninstall return code $Proc.ExitCode"
					# Next tweak now
					Return
				}
			}
			Start-Sleep -Seconds 2
		}
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function Tweak*
