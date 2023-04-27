################################################################
# Win 10 / Server 2016 / Server 2019 SWMB Script - Main execution loop
# Project CNRS RESINFO SWMB
# Copyright (c) 2017-2020, Disassembler <disassembler@dasm.cz>
# Copyright (C) 2020-2023, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
# Authors:
#  2017 - Disassembler <disassembler@dasm.cz>
#  2021 - Gabriel Moreau (CNRS / LEGI)
#  2021 - Olivier de Marchi (Grenoble INP / LEGI)
# Version: v3.13, 2021-11-22
################################################################

Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 0 `
	-Message "SWMB: Run Logon Script for User $Env:UserName - Begin"

# Change Path to the root Installation Folder
$InstallFolder = (Join-Path -Path $Env:ProgramFiles -ChildPath "SWMB")
If (Test-Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SWMB") {
	$InstallFolder = (Get-ItemProperty -Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SWMB" -Name "InstallFolder").InstallFolder
}
Set-Location $InstallFolder

# Define Boot preset on ProgramData
$DataFolder   = (Join-Path -Path $Env:ProgramData -ChildPath "SWMB")
$LogonPreset  = (Join-Path -Path $DataFolder -ChildPath (Join-Path -Path "Presets" -ChildPath "CurrentUser-Logon.preset"))
$LogonModule  = (Join-Path -Path $DataFolder -ChildPath (Join-Path -Path "Modules" -ChildPath "CurrentUser-Logon.psm1"))
$LogonLog     = (Join-Path -Path $DataFolder -ChildPath (Join-Path -Path "Logs"    -ChildPath "CurrentUser-LastLogon.log"))

# Revert if not exist to module name Local-Addon.psm1
If (!(Test-Path -LiteralPath $LogonModule)) {
	$LogonModule = (Join-Path -Path $DataFolder -ChildPath (Join-Path -Path "Modules" -ChildPath "Local-Addon.psm1"))
}

# Build args
$Args = @()

# Log action
$Args += '-log', "$LogonLog"

# Add Local Module
If (Test-Path -LiteralPath $LogonModule) {
	$Args += '-import', "$LogonModule"
}

# Launch SWMB with this preset
If (Test-Path -LiteralPath $LogonPreset) {
	$Args += '-preset', "$LogonPreset"
	.\swmb.ps1 @Args
} Else {
	Write-Output "Error: No preset define, No SWMB launch"
}

Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 999 `
	-Message "SWMB: Run Logon Script for User $Env:UserName - End"
