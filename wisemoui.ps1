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
#  2021 - Olivier de Marchi (Grenoble INP / LEGI)
# Version: v3.12, 2021-07-10
################################################################

# Relaunch the script with administrator privileges
Function SysRequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
		Exit
	}
}
SysRequireAdmin

# Change Path to the root Installation Folder
$InstallFolder = (Join-Path -Path $Env:ProgramFiles -ChildPath "SWMB")
If (Test-Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SWMB") {
	$InstallFolder = (Get-ItemProperty -Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SWMB" -Name "InstallFolder").InstallFolder
}
Set-Location $InstallFolder

# Define Boot preset on ProgramData
$DataFolder  = (Join-Path -Path $Env:ProgramData -ChildPath "SWMB")
$BootLog     = (Join-Path -Path $DataFolder -ChildPath (Join-Path -Path "Logs" -ChildPath "LocalMachine-LastBoot.log"))


# Main Windows
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
$Form = New-Object System.Windows.Forms.Form
$Form.ClientSize = '300,300'
$Form.Text = "SWMB: Secure Windows Mode Batch"
    
$ButtonCrypt = New-Object System.Windows.Forms.Button
$ButtonCrypt.Location = New-Object System.Drawing.Point(30,50)
$ButtonCrypt.Width = 100
$ButtonCrypt.Height = 60
$ButtonCrypt.Text = "Crypt disks with Bitlocker"
$Form.controls.Add($ButtonCrypt)

$ButtonCrypt.Add_Click({
	& "$PSScriptRoot\Tasks\LocalMachine-Crypt-With-Bitlocker.ps1"
	If (((Get-Process -ProcessName 'mmc' -ErrorAction SilentlyContinue).Modules | Select-String 'EventViewer' | Measure-Object -Line).Lines -eq 0) {
		& eventvwr.exe /c:Application
	}
})

$ButtonBoot = New-Object System.Windows.Forms.Button
$ButtonBoot.Location = New-Object System.Drawing.Point(30,140)
$ButtonBoot.Width = 100
$ButtonBoot.Height = 60
$ButtonBoot.Text = "Run Boot Task Schedule Now"
$Form.controls.Add($ButtonBoot)

$ButtonBoot.Add_Click({
	& "$PSScriptRoot\Tasks\LocalMachine-Boot.ps1"
	If (((Get-Process -ProcessName 'mmc' -ErrorAction SilentlyContinue).Modules | Select-String 'EventViewer' | Measure-Object -Line).Lines -eq 0) {
		& eventvwr.exe /c:Application
	}
	#Start-Job -ScriptBlock { Get-Content $BootLog -Wait } | Receive-Job
})

$ButtonExit = New-Object System.Windows.Forms.Button
$ButtonExit.Location = New-Object System.Drawing.Point(160,230)
$ButtonExit.Width = 100
$ButtonExit.Height = 40
$ButtonExit.Text = " Exit "
$ButtonExit.Add_Click({
	$Form.Close()
})
$Form.controls.Add($ButtonExit)

$Form.ShowDialog()
