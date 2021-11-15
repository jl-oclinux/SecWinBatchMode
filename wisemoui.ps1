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
		Start-Process powershell.exe "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
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

Import-Module -Name "$PSScriptRoot\Modules\SWMB.psd1" -ErrorAction Stop
Import-Module -Name "$PSScriptRoot\Modules\WiSeMoUI.psm1" -ErrorAction Stop

#$VersionModule = (Join-Path -Path "$InstallFolder" -ChildPath (Join-Path -Path "Modules" (Join-Path -Path "SWMB" -ChildPath "Version.psd1")))
#$Version = ''
#If (Test-Path $VersionModule) {
#	Import-Module -Name $VersionModule -ErrorAction Stop
#	$Version = (Get-Module -Name Version).Version.ToString()
#}
#$SWMB_Url = 'https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb'
#$NextVersion = ((Invoke-WebRequest -Uri "$SWMB_Url/version.txt" -Method Get -ErrorAction SilentlyContinue).Content)



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
$BtnBitlockerStatus.Location = New-Object System.Drawing.Size(30,15)
$BtnBitlockerStatus.Width = 230
$BtnBitlockerStatus.Height = 30
$BtnBitlockerStatus.BackColor = "Transparent"
$BtnBitlockerStatus.Text = "Bitlocker: $BitlockerStatus"
$Form.Controls.Add($BtnBitlockerStatus)

# Crypt  
$ButtonCrypt = New-Object System.Windows.Forms.Button
$ButtonCrypt.Location = New-Object System.Drawing.Point(30,50)
$ButtonCrypt.Width = 100
$ButtonCrypt.Height = 60
$ButtonCrypt.Text = "Crypt all Disks with Bitlocker"
$Form.controls.Add($ButtonCrypt)
$ButtonCrypt.Add_Click({
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
		$BtnBitlockerStatus.Text = "Bitlocker: $BitlockerStatus"
	} ElseIf ($BitlockerAction -eq "Halt") {
		Stop-Computer -ComputerName localhost
	} Else {
		Get-BitLockerVolume | Resume-BitLocker
		$BitlockerStatus = SWMB_GetBitLockerStatus -Drive $Env:SystemDrive
		If ($BitlockerStatus -cmatch "Running") {
			$BitlockerAction  = "Suspend"
			$BtnBitlockerAction.Text = "$BitlockerAction"
			$BtnBitlockerStatus.Text = "Bitlocker: $BitlockerStatus"
		}
	}
})


# Boot Task
$BtnBootStatus = New-Object System.Windows.Forms.label
$BtnBootStatus.Location = New-Object System.Drawing.Size(140,160)
#$BtnBootStatus.Size = New-Object System.Drawing.Size(100,60)
$BtnBootStatus.Width = 100
$BtnBootStatus.Height = 40
$BtnBootStatus.BackColor = "Transparent"
$BtnBootStatus.Text = ""
$Form.Controls.Add($BtnBootStatus)

$ButtonBoot = New-Object System.Windows.Forms.Button
$ButtonBoot.Location = New-Object System.Drawing.Point(30,140)
$ButtonBoot.Width = 100
$ButtonBoot.Height = 60
$ButtonBoot.Text = "Run Boot Task Schedule Now"
$Form.controls.Add($ButtonBoot)

$ButtonBoot.Add_Click({
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

$ButtonExit = New-Object System.Windows.Forms.Button
$ButtonExit.Location = New-Object System.Drawing.Point(310,230)
$ButtonExit.Width = 100
$ButtonExit.Height = 40
$ButtonExit.Text = "Exit"
$ButtonExit.Add_Click({
	$Form.Close()
})
$Form.controls.Add($ButtonExit)

$Form.ShowDialog()
