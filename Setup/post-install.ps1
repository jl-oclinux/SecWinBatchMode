################################################################
# Win 10 / Server 2016 / Server 2019 SWMB Script - Main execution loop
# Project CNRS RESINFO SWMB
# Copyright (c) 2017-2020, Disassembler <disassembler@dasm.cz>
# Copyright (C) 2020-2021, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb
# Authors:
#  2017 - Disassembler <disassembler@dasm.cz>
#  2021 - Gabriel Moreau (CNRS / LEGI)
# Version: v3.12, 2021-07-10
################################################################

# This script must be run as an administrator with privileges.
# It copies all SWMB files to the local computer's application installation
# folder and creates a scheduled task that runs the script when the
# computer starts.

#Param (
#	# Installation Folder
#	# $InstallFolder  = (Join-Path -Path $Env:ProgramFiles -ChildPath "SWMB")
#	[Parameter(Mandatory = $true)] [string]$InstallFolder
#)

# Installation Folder
$InstallFolder = (Join-Path -Path $Env:ProgramFiles -ChildPath "SWMB")
If (Test-Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SWMB") {
	$InstallFolder = (Get-ItemProperty -Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SWMB" -Name "InstallFolder").InstallFolder
}

# Create ProgramData Folders
$DataFolder  = (Join-Path -Path $Env:ProgramData -ChildPath "SWMB")
$DataPresets = (Join-Path -Path $DataFolder      -ChildPath "Presets")

If (Test-Path -LiteralPath $Env:ProgramData) {
	If (!(Test-Path -LiteralPath $DataFolder)) {
		New-Item -Path $DataFolder -ItemType Directory
	}

	If (!(Test-Path -LiteralPath $DataPresets)) {
		New-Item -Path $DataPresets -ItemType Directory
	}
}

# Create Boot Task
If (Test-Path -LiteralPath "$InstallFolder\Tasks\LocalMachine-Boot.ps1") {
	$BootTrigger = New-ScheduledTaskTrigger -AtStartup
	$User        = "NT AUTHORITY\SYSTEM"
	$BootTask    = 'SWMB-LocalMachine-Boot'
	$BootAction  = New-ScheduledTaskAction -Execute "powershell.exe" `
		-Argument "-File `"$InstallFolder\Tasks\LocalMachine-Boot.ps1`"" `
		-WorkingDirectory "$InstallFolder"
	Unregister-ScheduledTask -TaskName $BootTask -Confirm:$false -ErrorAction SilentlyContinue
	Register-ScheduledTask -Force -TaskName $BootTask -Trigger $BootTrigger -User $User -Action $BootAction `
		-RunLevel Highest -Description "SWMB tweaks action at boot"
	$BootObject = Get-ScheduledTask $BootTask
	$BootObject.Author = "CNRS RESINFO / GT SWMB"
	$BootObject | Set-ScheduledTask
}

# Create Logon Task for All Users
If (Test-Path -LiteralPath "$InstallFolder\Tasks\CurrentUser-Logon.ps1") {
	$LogonTrigger = New-ScheduledTaskTrigger -AtLogon
	$LogonTask    = 'SWMB-CurrentUser-Logon'
	$LogonAction  = New-ScheduledTaskAction -Execute "powershell.exe" `
		-Argument "-File `"$InstallFolder\Tasks\CurrentUser-Logon.ps1`"" `
		-WorkingDirectory "$InstallFolder"
	Unregister-ScheduledTask -TaskName $LogonTask -Confirm:$false -ErrorAction SilentlyContinue
	Register-ScheduledTask -Force -TaskName $LogonTask -Trigger $LogonTrigger -Action $LogonAction `
		-RunLevel Highest -Description "SWMB tweaks action at user logon"
	$LogonObject = Get-ScheduledTask $LogonTask
	$LogonObject.Author = "CNRS RESINFO / GT SWMB"
	$LogonObject | Set-ScheduledTask
}

#$StartUp = "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
#If ((Test-Path -LiteralPath $StartUp) -And (Test-Path -LiteralPath "$InstallFolder\Tasks\CurrentUser-Logon.ps1")) {
#	If (Test-Path -LiteralPath "$StartUp\SWMB-CurrentUser-Logon.lnk") {
#		Remove-Item "$StartUp\SWMB-CurrentUser-Logon.lnk" -Force -ErrorAction SilentlyContinue
#	}
#	$WshShell = New-Object -ComObject WScript.Shell
#	$Shortcut = $WshShell.CreateShortcut("$StartUp\SWMB-CurrentUser-Logon.lnk")
#	$Shortcut.TargetPath = "$InstallFolder\Tasks\CurrentUser-Logon.ps1"
#	$Shortcut.Save()
#}

# Create EventLog for our Source
If ([System.Diagnostics.EventLog]::SourceExists("SWMB") -eq $False) {
	New-EventLog -LogName "Application" -Source "SWMB"
}

# Unblock Powershell Script
#If (Test-Path $InstallFolder) {
#	Get-ChildItem -Path "$InstallFolder" -Recurse | Unblock-File
#}
