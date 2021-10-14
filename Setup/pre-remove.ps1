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

# Destroy Boot Task
$BootTask   = 'SWMB-LocalMachine-Boot'
Unregister-ScheduledTask -TaskName $BootTask -Confirm:$false -ErrorAction SilentlyContinue
