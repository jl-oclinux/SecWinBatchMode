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

Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 10 `
	-Message "SWMB: Run Boot Script for LocalMachine - Begin"

# Change Path to the root Installation Folder
$InstallFolder = (Join-Path -Path $Env:ProgramFiles -ChildPath "SWMB")
If (Test-Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SWMB") {
	$InstallFolder = (Get-ItemProperty -Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SWMB" -Name "InstallFolder").InstallFolder
}
Set-Location $InstallFolder

# Define Boot preset on ProgramData
$DataFolder  = (Join-Path -Path $Env:ProgramData -ChildPath "SWMB")
$BootPreset  = (Join-Path -Path $DataFolder -ChildPath (Join-Path -Path "Presets" -ChildPath "LocalMachine-Boot.preset"))
$BootModule  = (Join-Path -Path $DataFolder -ChildPath (Join-Path -Path "Modules" -ChildPath "LocalMachine-Boot.psm1"))

# Launch SWMB with this preset
If (Test-Path -LiteralPath $BootPreset) {
	If (Test-Path -LiteralPath $BootModule) {
		.\swmb.ps1 -include $BootModule -preset $BootPreset
	} Else {
		.\swmb.ps1 -preset $BootPreset
	}
}

Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 999 `
	-Message "SWMB: Run Boot Script for LocalMachine - End"
