################################################################
# Win 10 / Server 2016 / Server 2019 SWMB Script - Main execution loop
# Project CNRS RESINFO SWMB
# Copyright (c) 2017-2020, Disassembler <disassembler@dasm.cz>
# Copyright (C) 2020-2021, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
# Authors:
#  2017 - Disassembler <disassembler@dasm.cz>
#  2021 - Gabriel Moreau (CNRS / LEGI)
# Version: v3.12, 2021-07-10
################################################################

# This script must be run as an administrator with privileges.

# Destroy Boot Task
$BootTask = 'SWMB-LocalMachine-Boot'
Unregister-ScheduledTask -TaskName $BootTask -Confirm:$false -ErrorAction SilentlyContinue

# Destroy Logon script for All Users
$LogonTask = 'SWMB-CurrentUser-Logon'
Unregister-ScheduledTask -TaskName $LogonTask -Confirm:$false -ErrorAction SilentlyContinue
#$LogonTask = "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\SWMB-CurrentUser-Logon.lnk"
#If (Test-Path -LiteralPath $LogonTask) {
#	Remove-Item $LogonTask -Force -ErrorAction SilentlyContinue
#}

# Destroy ProgramData Folders if Empty
$DataFolder  = (Join-Path -Path $Env:ProgramData -ChildPath "SWMB")
$DataPresets = (Join-Path -Path $DataFolder      -ChildPath "Presets")

If (Test-Path -LiteralPath $DataPresets) {
	if((Get-ChildItem $DataPresets).Count -eq 0) {
		Remove-Item $DataPresets -Force -ErrorAction SilentlyContinue
	}
}

If (Test-Path -LiteralPath $DataFolder) {
	if((Get-ChildItem $DataFolder).Count -eq 0) {
		Remove-Item $DataFolder -Force -ErrorAction SilentlyContinue
	}
}
