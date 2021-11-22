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
# Version: v3.13, 2021-11-22
################################################################

# Relaunch the script with administrator privileges
Function SysRequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
		Exit
	}
}
SysRequireAdmin

# Define Boot preset on ProgramData
$DataFolder  = (Join-Path -Path $Env:ProgramData -ChildPath "SWMB")
$BootLog     = (Join-Path -Path $DataFolder -ChildPath (Join-Path -Path "Logs" -ChildPath "LocalMachine-LastBoot.log"))

Import-Module -Name "$PSScriptRoot\Modules\SWMB.psd1" -ErrorAction Stop
Import-Module -Name "$PSScriptRoot\Modules\WiSeMoUI.psm1" -ErrorAction Stop

# Main Windows
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
$Form = New-Object System.Windows.Forms.Form
$Form.ClientSize = '500,300'
$Form.Text = "SWMB: Secure Windows Mode Batch"

# Logo
$Logo = New-Object System.Windows.Forms.PictureBox
$Logo.Location = New-Object Drawing.Point(270,10)
$Logo.Size = New-Object System.Drawing.Size(200,201)
$Logo.image = [system.drawing.image]::FromFile("$PSScriptRoot\logo-swmb.ico")
$Form.Controls.Add($Logo)

# Bitlocker Status
$BitlockerStatus  = SWMB_GetBitLockerStatus -Drive $Env:SystemDrive
$BtnBitlockerStatus = New-Object System.Windows.Forms.label
$BtnBitlockerStatus.Location = New-Object System.Drawing.Size(30,25)
$BtnBitlockerStatus.Width = 220
$BtnBitlockerStatus.Height = 20
$BtnBitlockerStatus.BackColor = "Transparent"
$BtnBitlockerStatus.Text = "Status: $BitlockerStatus"
$Form.Controls.Add($BtnBitlockerStatus)

# Bitlocker Crypt  
$BtnCrypt = New-Object System.Windows.Forms.Button
$BtnCrypt.Location = New-Object System.Drawing.Point(30,50)
$BtnCrypt.Width = 100
$BtnCrypt.Height = 60
$BtnCrypt.Text = "Crypt all Disks with Bitlocker"
$Form.controls.Add($BtnCrypt)
$BtnCrypt.Add_Click({
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\Tasks\LocalMachine-Crypt-With-Bitlocker.ps1`"" -WindowStyle Normal
})

# Bitlocker Action
$BitlockerAction  = "Suspend"
If ($BitlockerStatus -cmatch "Suspend") {
	$BitlockerAction  = "Resume"
}
$BtnBitlockerAction = New-Object System.Windows.Forms.Button
$BtnBitlockerAction.Location = New-Object System.Drawing.Point(150,50)
$BtnBitlockerAction.Width = 80
$BtnBitlockerAction.Height = 60
$BtnBitlockerAction.BackColor = "Transparent"
$BtnBitlockerAction.Text = "$BitlockerAction"
$Form.Controls.Add($BtnBitlockerAction)
$BtnBitlockerAction.Add_Click({
	If ($BitlockerAction -eq "Suspend") {
		Suspend-BitLocker -MountPoint "$Env:SystemDrive" -RebootCount 0
		$BitlockerAction = "Halt"
		$BitlockerStatus = SWMB_GetBitLockerStatus -Drive $Env:SystemDrive
		$BtnBitlockerAction.Text = "Please Halt for your Maintenance"
		$BtnBitlockerStatus.Text = "Status: $BitlockerStatus"
	} ElseIf ($BitlockerAction -eq "Halt") {
		Stop-Computer -ComputerName localhost
	} Else {
		Get-BitLockerVolume | Resume-BitLocker
		$BitlockerStatus = SWMB_GetBitLockerStatus -Drive $Env:SystemDrive
		If ($BitlockerStatus -cmatch "Running") {
			$BitlockerAction  = "Suspend"
			$BtnBitlockerAction.Text = "$BitlockerAction"
			$BtnBitlockerStatus.Text = "Status: $BitlockerStatus"
		}
	}
})

# Bitlocker Frame
$BtnBitlockerFrame = New-Object System.Windows.Forms.GroupBox
$BtnBitlockerFrame.Location = New-Object System.Drawing.Size(20,10)
$BtnBitlockerFrame.Width = 240
$BtnBitlockerFrame.Height = 110
#$BtnBitlockerFrame.BackColor = "Transparent"
$BtnBitlockerFrame.Text = "Bitlocker"
$Form.Controls.Add($BtnBitlockerFrame)    

# Boot Task
$BtnBootStatus = New-Object System.Windows.Forms.label
$BtnBootStatus.Location = New-Object System.Drawing.Size(140,160)
#$BtnBootStatus.Size = New-Object System.Drawing.Size(100,60)
$BtnBootStatus.Width = 100
$BtnBootStatus.Height = 40
$BtnBootStatus.BackColor = "Transparent"
$BtnBootStatus.Text = ""
$Form.Controls.Add($BtnBootStatus)

$BtnBoot = New-Object System.Windows.Forms.Button
$BtnBoot.Location = New-Object System.Drawing.Point(30,140)
$BtnBoot.Width = 100
$BtnBoot.Height = 60
$BtnBoot.Text = "Run Boot Task Schedule Now"
$Form.controls.Add($BtnBoot)
$BtnBoot.Add_Click({
	$BtnBootStatus.Text = "Start..."
	If (((Get-Process -ProcessName 'mmc' -ErrorAction SilentlyContinue).Modules | Select-String 'EventViewer' | Measure-Object -Line).Lines -eq 0) {
		& eventvwr.exe /c:Application
	}
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\Tasks\LocalMachine-Boot.ps1`"" -WindowStyle Hidden -Wait
	Start-Process notepad.exe "`"$BootLog`""
	$BtnBootStatus.Text = "Finish!"
})

# Version
$RunningVersion  = (SWMB_GetRunningVersion)
$PublishedVersion = (SWMB_GetLastPublishedVersion)
$BtnVersion = New-Object System.Windows.Forms.label
$BtnVersion.Location = New-Object System.Drawing.Size(30,240)
$BtnVersion.Width = 120
$BtnVersion.Height = 40
$BtnVersion.BackColor = "Transparent"
$BtnVersion.Text = "Version: $RunningVersion"
$Form.Controls.Add($BtnVersion)

If ($RunningVersion -ne $PublishedVersion) {
	$BtnUpdate = New-Object System.Windows.Forms.Button
	$BtnUpdate.Location = New-Object System.Drawing.Point(150,230)
	$BtnUpdate.Width = 120
	$BtnUpdate.Height = 40
	$BtnUpdate.Text = "New release available"
	$Form.controls.Add($BtnUpdate)

	$BtnUpdate.Add_Click({
		Start-Process "$SWMB_Url"
	})
}

# Exit
$BtnExit = New-Object System.Windows.Forms.Button
$BtnExit.Location = New-Object System.Drawing.Point(310,230)
$BtnExit.Width = 100
$BtnExit.Height = 40
$BtnExit.Text = "Exit"
$BtnExit.Add_Click({
	$Form.Close()
})
$Form.controls.Add($BtnExit)

# Main Loop
$Form.ShowDialog()
