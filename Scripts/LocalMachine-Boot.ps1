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


$DataFolder  = (Join-Path -Path $Env:ProgramData -ChildPath "SWMB")
$DataPresets = (Join-Path -Path $DataFolder      -ChildPath "Presets")
$BootPreset  = (Join-Path -Path $DataPresets     -ChildPath "LocalMachine-Boot.preset")

If (Test-Path -LiteralPath $BootPreset) {
	..\swmb.ps1 $BootPreset
}
