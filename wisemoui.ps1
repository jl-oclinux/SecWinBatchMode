################################################################
# Win 10 / Server 2016 / Server 2019 SWMB Script - Main execution loop
# Project CNRS RESINFO SWMB
# Copyright (c) 2017-2020, Disassembler <disassembler@dasm.cz>
# Copyright (C) 2020-2025, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
# Authors:
#  2017 - Disassembler <disassembler@dasm.cz>
#  2021 - Gabriel Moreau (CNRS / LEGI)
#  2021 - Olivier de Marchi (Grenoble INP / LEGI)
# Version: v3.13, 2021-11-22
################################################################

# List of Color https://learn.microsoft.com/en-us/dotnet/api/system.windows.media.brushes?view=windowsdesktop-9.0

# Relaunch the script with administrator privileges
Function TweakSysRequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
		Exit
	}
}
TweakSysRequireAdmin

# Define Boot preset on ProgramData
$DataFolder  = (Join-Path -Path ${Env:ProgramData} -ChildPath "SWMB")
$BootLog        = (Join-Path -Path $DataFolder -ChildPath (Join-Path -Path "Logs" -ChildPath "LocalMachine-LastBoot.log"))
$PostInstallLog = (Join-Path -Path $DataFolder -ChildPath (Join-Path -Path "Logs" -ChildPath "LocalMachine-PostInstall.log"))
$LogonLog       = (Join-Path -Path $DataFolder -ChildPath (Join-Path -Path "Logs" -ChildPath "CurrentUser-LastLogon.log"))

Import-Module -Name "$PSScriptRoot\Modules\SWMB.psd1" -ErrorAction Stop
Import-Module -Name "$PSScriptRoot\Modules\WiSeMoUI.psm1" -ErrorAction Stop

$Uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$day = 'day'
If ($Uptime.Days -gt 1) { $day = 'days' }
$hour = 'hour'
If ($Uptime.Hours -gt 1) { $hour = 'hours' }

If ($Uptime.Days -ne 0) {
	$UptimeStr = "$($Uptime.Days) $day, $($Uptime.Hours) $hour"
} ElseIf ($Uptime.Hours -ne 0) {
	$UptimeStr = "$($Uptime.Hours) $hour, $($Uptime.Minutes) min"
} Else {
	$UptimeStr = "$($Uptime.Minutes) min"
}

# Default editor
# $Editor = ((Get-ItemProperty -Path 'Registry::HKEY_CLASSES_ROOT\txtfile\shell\open\command').'(Default)').trimend(" %1")
$Editor = "${Env:SystemRoot}\System32\notepad.exe"
If (Test-Path -LiteralPath "${Env:ProgramFiles}\Notepad++\notepad++.exe") {
	$Editor = "${Env:ProgramFiles}\Notepad++\notepad++.exe"
}

# Main Windows
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
$Form = New-Object System.Windows.Forms.Form
$Form.ClientSize = '550,390'
$Form.Text = "SWMB: Secure Windows Mode Batch / $UptimeStr"

# Logo
$Logo = New-Object System.Windows.Forms.PictureBox
$Logo.Location = New-Object Drawing.Point(320,30)
$Logo.Size = New-Object System.Drawing.Size(200,201)
$Logo.image = [system.drawing.image]::FromFile("$PSScriptRoot\logo-swmb.ico")
$Form.Controls.Add($Logo)

################################################################
# Bitlocker Frame

# Bitlocker Status
$BitlockerStatus  = SWMB_GetBitLockerStatus -Drive ${Env:SystemDrive}
$BtnBitlockerStatus = New-Object System.Windows.Forms.Label
$BtnBitlockerStatus.Location = New-Object System.Drawing.Size(30,25)
$BtnBitlockerStatus.Width = 220
$BtnBitlockerStatus.Height = 20
$BtnBitlockerStatus.BackColor = "Transparent"
$BtnBitlockerStatus.Text = "Status: $BitlockerStatus"
$Form.Controls.Add($BtnBitlockerStatus)

# Bitlocker Crypt
$BtnCrypt = New-Object System.Windows.Forms.Button
$BtnCrypt.Location = New-Object System.Drawing.Point(30,50)
$BtnCrypt.Width = 110
$BtnCrypt.Height = 60
$BtnCrypt.Text = "Crypt all Disks`nwith Bitlocker"
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
$BtnBitlockerAction.Location = New-Object System.Drawing.Point(170,50)
$BtnBitlockerAction.Width = 80
$BtnBitlockerAction.Height = 60
$BtnBitlockerAction.BackColor = "Transparent"
$BtnBitlockerAction.Text = "$BitlockerAction"
$Form.Controls.Add($BtnBitlockerAction)
$BtnBitlockerAction.Add_Click({
	If ($BitlockerAction -eq "Suspend") {
		Get-BitLockerVolume | Suspend-BitLocker -RebootCount 0
		$BitlockerAction = "Halt"
		$BitlockerStatus = SWMB_GetBitLockerStatus -Drive ${Env:SystemDrive}
		$BtnBitlockerAction.Text = "Please Halt for your Maintenance"
		$BtnBitlockerStatus.Text = "Status: $BitlockerStatus"
	} ElseIf ($BitlockerAction -eq "Halt") {
		Stop-Computer -ComputerName localhost
	} Else {
		Get-BitLockerVolume | Resume-BitLocker
		$BitlockerStatus = SWMB_GetBitLockerStatus -Drive ${Env:SystemDrive}
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
$BtnBitlockerFrame.Width = 250
$BtnBitlockerFrame.Height = 110
#$BtnBitlockerFrame.BackColor = "Transparent"
$BtnBitlockerFrame.Text = "Bitlocker"
$Form.Controls.Add($BtnBitlockerFrame)

################################################################
# Task Frame

# General ToolTip
$ToolTip = New-Object System.Windows.Forms.ToolTip;
$ToolTip.AutoPopDelay = 5000;
$ToolTip.InitialDelay = 500;
$ToolTip.ReshowDelay = 500;
$ToolTip.ShowAlways = true;

# Boot Task
$BtnTaskBootStatus = New-Object System.Windows.Forms.Label
$BtnTaskBootStatus.Location = New-Object System.Drawing.Size(40,212)
$BtnTaskBootStatus.Width = 50
$BtnTaskBootStatus.Height = 15
$BtnTaskBootStatus.BackColor = "Transparent"
$BtnTaskBootStatus.Text = ""
$Form.Controls.Add($BtnTaskBootStatus)

$BtnTaskBootLabel = New-Object System.Windows.Forms.Label
$BtnTaskBootLabel.Location = New-Object System.Drawing.Point(40,160)
$BtnTaskBootLabel.Width = 50
$BtnTaskBootLabel.Height = 30
$BtnTaskBootLabel.Text = "Boot"
$BtnTaskBootLabel.BackColor = 'Moccasin'
$Form.controls.Add($BtnTaskBootLabel)

$BtnTaskBootRun = New-Object System.Windows.Forms.Button
$BtnTaskBootRun.Location = New-Object System.Drawing.Point(30,190)
$BtnTaskBootRun.Width = 44
$BtnTaskBootRun.Height = 20
$BtnTaskBootRun.Text = "Run"
$Form.controls.Add($BtnTaskBootRun)
$BtnTaskBootRun.Add_Click({
	$BtnTaskBootStatus.Text = "Start..."
	If (((Get-Process -ProcessName 'mmc' -ErrorAction SilentlyContinue).Modules | Select-String 'EventViewer' | Measure-Object -Line).Lines -eq 0) {
		& eventvwr.exe /c:Application
	}
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\Tasks\LocalMachine-Boot.ps1`"" -WindowStyle Hidden -Wait
	Start-Process $Editor "`"$BootLog`""
	$BtnTaskBootStatus.Text = "Finish!"
})

$BtnTaskBootCheck = New-Object System.Windows.Forms.Button
$BtnTaskBootCheck.Location = New-Object System.Drawing.Point(74,190)
$BtnTaskBootCheck.Width = 15
$BtnTaskBootCheck.Height = 20
$BtnTaskBootCheck.Text = "C"
$Form.controls.Add($BtnTaskBootCheck)
$BtnTaskBootCheck.Add_Click({
#	$BtnTaskBootStatus.Text = "Check..."
#	$Message = @(& $PSScriptRoot\Tasks\LocalMachine-Boot.ps1 -Mode Check)
#	$TempWindow = New-Object System.Windows.Forms.Form -Property @{TopMost = $True}
#	$TextBox                      = New-Object System.Windows.Forms.TextBox
#	$TextBox.Multiline            = $true
#	$TextBox.Text                 = $Message -join "`r`n"
#	$TextBox.Font                 = New-Object System.Drawing.Font("Consolas",9,[System.Drawing.FontStyle]::Regular)
#	$TextBox.Size                 = New-Object System.Drawing.Size(400,400)
#	$TextBox.Location             = New-Object System.Drawing.Point(20,70)
#	$TextBox.Scrollbars          = "Vertical"
#	$TextBox.BackColor            = "#1F1F1F"
#	$TextBox.ForeColor            = 'Cyan'
#	$TempWindow.Controls.Add($TextBox)
#	$TempWindow.ShowDialog() # | Out-String
	& $PSScriptRoot\Tasks\LocalMachine-Boot.ps1 -Mode Check `
		| Out-GridView -Title "SWMB: Check Boot sequence tweaks on the ${Env:ComputerName} computer - $(Get-Date)"
})

$BtnTaskBootPrint = New-Object System.Windows.Forms.Button
$BtnTaskBootPrint.Location = New-Object System.Drawing.Point(89,150)
$BtnTaskBootPrint.Width = 15
$BtnTaskBootPrint.Height = 20
$BtnTaskBootPrint.Text = "P"
$Form.controls.Add($BtnTaskBootPrint)
$BtnTaskBootPrint.Add_Click({
	& $PSScriptRoot\Tasks\LocalMachine-Boot.ps1 -Mode Print `
		| ForEach-Object -Begin {$CountTweak = 0} -Process {
			$CountTweak++
			$_ | Select-Object -Property @{Name="Num"; Expression={$CountTweak}}, @{Label="Tweak"; Expression={$_}}
			} `
		| Out-GridView -Title "SWMB: Tweaks that will apply to the next Boot sequence on the ${Env:ComputerName} computer - $(Get-Date)"
})
$BtnTaskBootLog = New-Object System.Windows.Forms.Button
$BtnTaskBootLog.Location = New-Object System.Drawing.Point(89,170)
$BtnTaskBootLog.Width = 15
$BtnTaskBootLog.Height = 20
$BtnTaskBootLog.Text = "L"
$Form.controls.Add($BtnTaskBootLog)
$BtnTaskBootLog.Add_Click({
	Start-Process $Editor "`"$BootLog`""
})
$BtnTaskBootEdit = New-Object System.Windows.Forms.Button
$BtnTaskBootEdit.Location = New-Object System.Drawing.Point(89,190)
$BtnTaskBootEdit.Width = 15
$BtnTaskBootEdit.Height = 20
$BtnTaskBootEdit.Text = "E"
$Form.controls.Add($BtnTaskBootEdit)
$BtnTaskBootEdit.Add_Click({
	Start-Process $Editor "`"$DataFolder\Presets\LocalMachine-Boot.preset`""
})

$BtnTaskBootFrame = New-Object System.Windows.Forms.GroupBox
$BtnTaskBootFrame.Location = New-Object System.Drawing.Size(30,145)
$BtnTaskBootFrame.Width = 60
$BtnTaskBootFrame.Height = 47
$BtnTaskBootFrame.Text = ""
$BtnTaskBootFrame.BackColor = 'Moccasin'
$Form.Controls.Add($BtnTaskBootFrame)

$ToolTip.SetToolTip($BtnTaskBootCheck, "Check Boot Tweaks");
$ToolTip.SetToolTip($BtnTaskBootRun,   "Run Boot Task Now");
$ToolTip.SetToolTip($BtnTaskBootPrint, "Print Boot Tweaks List");
$ToolTip.SetToolTip($BtnTaskBootLog,   "Show Last Boot Task Run");
$ToolTip.SetToolTip($BtnTaskBootEdit,  "Edit Boot Task Preset File");


# Post-Install Task
$BtnTaskPostInstallStatus = New-Object System.Windows.Forms.Label
$BtnTaskPostInstallStatus.Location = New-Object System.Drawing.Size(120,212)
$BtnTaskPostInstallStatus.Width = 50
$BtnTaskPostInstallStatus.Height = 15
$BtnTaskPostInstallStatus.BackColor = "Transparent"
$BtnTaskPostInstallStatus.Text = ""
$Form.Controls.Add($BtnTaskPostInstallStatus)

#$BtnTaskPostInstall = New-Object System.Windows.Forms.Button
#$BtnTaskPostInstall.Location = New-Object System.Drawing.Point(110,150)
#$BtnTaskPostInstall.Width = 60
#$BtnTaskPostInstall.Height = 60
#$BtnTaskPostInstall.Text = "Post Install"
#$Form.controls.Add($BtnTaskPostInstall)
#$BtnTaskPostInstall.Add_Click({
#})

$BtnTaskPostInstallLabel = New-Object System.Windows.Forms.Label
$BtnTaskPostInstallLabel.Location = New-Object System.Drawing.Point(120,160)
$BtnTaskPostInstallLabel.Width = 50
$BtnTaskPostInstallLabel.Height = 30
$BtnTaskPostInstallLabel.Text = "Post`nInstall"
$BtnTaskPostInstallLabel.BackColor = 'Moccasin'
$Form.controls.Add($BtnTaskPostInstallLabel)

$BtnTaskPostInstallRun = New-Object System.Windows.Forms.Button
$BtnTaskPostInstallRun.Location = New-Object System.Drawing.Point(110,190)
$BtnTaskPostInstallRun.Width = 44
$BtnTaskPostInstallRun.Height = 20
$BtnTaskPostInstallRun.Text = "Run"
$Form.controls.Add($BtnTaskPostInstallRun)
$BtnTaskPostInstallRun.Add_Click({
	$BtnTaskPostInstallStatus.Text = "Start..."
	If (((Get-Process -ProcessName 'mmc' -ErrorAction SilentlyContinue).Modules | Select-String 'EventViewer' | Measure-Object -Line).Lines -eq 0) {
		& eventvwr.exe /c:Application
	}
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\Tasks\LocalMachine-PostInstall.ps1`"" -WindowStyle Hidden -Wait
	Start-Process $Editor "`"$PostInstallLog`""
	$BtnTaskPostInstallStatus.Text = "Finish!"
})

$BtnTaskPostInstallCheck = New-Object System.Windows.Forms.Button
$BtnTaskPostInstallCheck.Location = New-Object System.Drawing.Point(154,190)
$BtnTaskPostInstallCheck.Width = 15
$BtnTaskPostInstallCheck.Height = 20
$BtnTaskPostInstallCheck.Text = "C"
$Form.controls.Add($BtnTaskPostInstallCheck)
$BtnTaskPostInstallCheck.Add_Click({
	& $PSScriptRoot\Tasks\LocalMachine-PostInstall.ps1 -Mode Check `
		| Out-GridView -Title "SWMB: Check PostInstall sequence tweaks on the ${Env:ComputerName} computer - $(Get-Date)"
})

$BtnTaskPostInstallPrint = New-Object System.Windows.Forms.Button
$BtnTaskPostInstallPrint.Location = New-Object System.Drawing.Point(169,150)
$BtnTaskPostInstallPrint.Width = 15
$BtnTaskPostInstallPrint.Height = 20
$BtnTaskPostInstallPrint.Text = "P"
$Form.controls.Add($BtnTaskPostInstallPrint)
$BtnTaskPostInstallPrint.Add_Click({
	& $PSScriptRoot\Tasks\LocalMachine-PostInstall.ps1 -Mode Print `
		| ForEach-Object -Begin {$CountTweak = 0} -Process {
			$CountTweak++
			$_ | Select-Object -Property @{Name="Num"; Expression={$CountTweak}}, @{Label="Tweak"; Expression={$_}}
			} `
		| Out-GridView -Title "SWMB: Tweaks that will apply to the next Post-Install sequence on the ${Env:ComputerName} computer - $(Get-Date)"
})
$BtnTaskPostInstallLog = New-Object System.Windows.Forms.Button
$BtnTaskPostInstallLog.Location = New-Object System.Drawing.Point(169,170)
$BtnTaskPostInstallLog.Width = 15
$BtnTaskPostInstallLog.Height = 20
$BtnTaskPostInstallLog.Text = "L"
$Form.controls.Add($BtnTaskPostInstallLog)
$BtnTaskPostInstallLog.Add_Click({
	Start-Process $Editor "`"$PostInstallLog`""
})
$BtnTaskPostInstallEdit = New-Object System.Windows.Forms.Button
$BtnTaskPostInstallEdit.Location = New-Object System.Drawing.Point(169,190)
$BtnTaskPostInstallEdit.Width = 15
$BtnTaskPostInstallEdit.Height = 20
$BtnTaskPostInstallEdit.Text = "E"
$Form.controls.Add($BtnTaskPostInstallEdit)
$BtnTaskPostInstallEdit.Add_Click({
	Start-Process $Editor "`"$DataFolder\Presets\LocalMachine-PostInstall.preset`""
})

$BtnTaskPostInstallFrame = New-Object System.Windows.Forms.GroupBox
$BtnTaskPostInstallFrame.Location = New-Object System.Drawing.Size(110,145)
$BtnTaskPostInstallFrame.Width = 60
$BtnTaskPostInstallFrame.Height = 47
$BtnTaskPostInstallFrame.Text = ""
$BtnTaskPostInstallFrame.BackColor = 'Moccasin'
$Form.Controls.Add($BtnTaskPostInstallFrame)

$ToolTip.SetToolTip($BtnTaskPostInstallCheck, "Check Post-Install Tweaks");
$ToolTip.SetToolTip($BtnTaskPostInstallRun,   "Run Post-Install Task Now");
$ToolTip.SetToolTip($BtnTaskPostInstallPrint, "Print Post-Install Tweaks List");
$ToolTip.SetToolTip($BtnTaskPostInstallLog,   "Show Last Post-Install Task Run");
$ToolTip.SetToolTip($BtnTaskPostInstallEdit,  "Edit Post-Install Task Preset File");


# Logon Task
$BtnTaskLogonStatus = New-Object System.Windows.Forms.Label
$BtnTaskLogonStatus.Location = New-Object System.Drawing.Size(200,212)
$BtnTaskLogonStatus.Width = 50
$BtnTaskLogonStatus.Height = 15
$BtnTaskLogonStatus.BackColor = "Transparent"
$BtnTaskLogonStatus.Text = ""
$Form.Controls.Add($BtnTaskLogonStatus)

#$BtnTaskLogon = New-Object System.Windows.Forms.Button
#$BtnTaskLogon.Location = New-Object System.Drawing.Point(190,150)
#$BtnTaskLogon.Width = 60
#$BtnTaskLogon.Height = 60
#$BtnTaskLogon.Text = "Logon"
#$Form.controls.Add($BtnTaskLogon)
#$BtnTaskLogon.Add_Click({
#})

$BtnTaskLogonLabel = New-Object System.Windows.Forms.Label
$BtnTaskLogonLabel.Location = New-Object System.Drawing.Point(200,160)
$BtnTaskLogonLabel.Width = 50
$BtnTaskLogonLabel.Height = 30
$BtnTaskLogonLabel.Text = "Logon"
$BtnTaskLogonLabel.BackColor = 'Moccasin'
$Form.controls.Add($BtnTaskLogonLabel)

$BtnTaskLogonRun = New-Object System.Windows.Forms.Button
$BtnTaskLogonRun.Location = New-Object System.Drawing.Point(190,190)
$BtnTaskLogonRun.Width = 44
$BtnTaskLogonRun.Height = 20
$BtnTaskLogonRun.Text = "Run"
$Form.controls.Add($BtnTaskLogonRun)
$BtnTaskLogonRun.Add_Click({
	$BtnTaskLogonStatus.Text = "Start..."
	If (((Get-Process -ProcessName 'mmc' -ErrorAction SilentlyContinue).Modules | Select-String 'EventViewer' | Measure-Object -Line).Lines -eq 0) {
		& eventvwr.exe /c:Application
	}
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\Tasks\CurrentUser-Logon.ps1`"" -WindowStyle Hidden -Wait
	Start-Process $Editor "`"$LogonLog`""
	$BtnTaskLogonStatus.Text = "Finish!"
})

$BtnTaskLogonCheck = New-Object System.Windows.Forms.Button
$BtnTaskLogonCheck.Location = New-Object System.Drawing.Point(234,190)
$BtnTaskLogonCheck.Width = 15
$BtnTaskLogonCheck.Height = 20
$BtnTaskLogonCheck.Text = "C"
$Form.controls.Add($BtnTaskLogonCheck)
$BtnTaskLogonCheck.Add_Click({
	& $PSScriptRoot\Tasks\CurrentUser-Logon.ps1 -Mode Check `
		| Out-GridView -Title "SWMB: Check CurrentUser Logon sequence tweaks on the ${Env:ComputerName} computer - $(Get-Date)"
})

$BtnTaskLogonPrint = New-Object System.Windows.Forms.Button
$BtnTaskLogonPrint.Location = New-Object System.Drawing.Point(249,150)
$BtnTaskLogonPrint.Width = 15
$BtnTaskLogonPrint.Height = 20
$BtnTaskLogonPrint.Text = "P"
$Form.controls.Add($BtnTaskLogonPrint)
$BtnTaskLogonPrint.Add_Click({
	& $PSScriptRoot\Tasks\CurrentUser-Logon.ps1 -Mode Print `
		| ForEach-Object -Begin {$CountTweak = 0} -Process {
			$CountTweak++
			$_ | Select-Object -Property @{Name="Num"; Expression={$CountTweak}}, @{Label="Tweak"; Expression={$_}}
			} `
		| Out-GridView -Title "SWMB: Tweaks that will apply to the next Logon sequence for current user ${Env:UserName} - $(Get-Date)"
})
$BtnTaskLogonLog = New-Object System.Windows.Forms.Button
$BtnTaskLogonLog.Location = New-Object System.Drawing.Point(249,170)
$BtnTaskLogonLog.Width = 15
$BtnTaskLogonLog.Height = 20
$BtnTaskLogonLog.Text = "L"
$Form.controls.Add($BtnTaskLogonLog)
$BtnTaskLogonLog.Add_Click({
	Start-Process $Editor "`"$LogonLog`""
})
$BtnTaskLogonEdit = New-Object System.Windows.Forms.Button
$BtnTaskLogonEdit.Location = New-Object System.Drawing.Point(249,190)
$BtnTaskLogonEdit.Width = 15
$BtnTaskLogonEdit.Height = 20
$BtnTaskLogonEdit.Text = "E"
$Form.controls.Add($BtnTaskLogonEdit)
$BtnTaskLogonEdit.Add_Click({
	Start-Process $Editor "`"$DataFolder\Presets\CurrentUser-Logon.preset`""
})

$BtnTaskLogonFrame = New-Object System.Windows.Forms.GroupBox
$BtnTaskLogonFrame.Location = New-Object System.Drawing.Size(190,145)
$BtnTaskLogonFrame.Width = 60
$BtnTaskLogonFrame.Height = 47
$BtnTaskLogonFrame.Text = ""
$BtnTaskLogonFrame.BackColor = 'Moccasin'
$Form.Controls.Add($BtnTaskLogonFrame)

$ToolTip.SetToolTip($BtnTaskLogonCheck, "Check Current User Logon Tweaks");
$ToolTip.SetToolTip($BtnTaskLogonRun,   "Run Current User Logon Task Now");
$ToolTip.SetToolTip($BtnTaskLogonPrint, "Print Current User Logon Tweaks List");
$ToolTip.SetToolTip($BtnTaskLogonLog,   "Show Last Current User Logon Task Run");
$ToolTip.SetToolTip($BtnTaskLogonEdit,  "Edit Current User Logon Task Preset File");


# Task Frame
$BtnTaskFrame = New-Object System.Windows.Forms.GroupBox
$BtnTaskFrame.Location = New-Object System.Drawing.Size(20,130)
$BtnTaskFrame.Width = 250
$BtnTaskFrame.Height = 100
#$BtnTaskFrame.BackColor = "Transparent"
$BtnTaskFrame.Text = "Run Scheduled Task Now"
$Form.Controls.Add($BtnTaskFrame)

################################################################

# Version
$RunningVersion  = (SWMB_GetRunningVersion)
$PublishedVersion = (SWMB_GetLastPublishedVersion)
$BtnVersion = New-Object System.Windows.Forms.Label
$BtnVersion.Location = New-Object System.Drawing.Size(30,270)
$BtnVersion.Width = 110
$BtnVersion.Height = 40
$BtnVersion.BackColor = "Transparent"
$BtnVersion.Text = "Version: $RunningVersion"
$Form.Controls.Add($BtnVersion)

If ($RunningVersion -ne $PublishedVersion) {
	$BtnUpdate = New-Object System.Windows.Forms.Button
	$BtnUpdate.Location = New-Object System.Drawing.Point(140,255)
	$BtnUpdate.Width = 110
	$BtnUpdate.Height = 50
	$BtnUpdate.BackColor = "PaleGreen"
	$BtnUpdate.Text = "New release available`n$PublishedVersion"
	$Form.controls.Add($BtnUpdate)

	$BtnUpdate.Add_Click({
		$HomeUrl = (SWMB_GetHomeURL)
		Start-Process "$HomeUrl"
	})
}

# Hostname
$HostId = (SWMB_GetHostId)
$BtnHost = New-Object System.Windows.Forms.Label
$BtnHost.Location = New-Object System.Drawing.Size(30,310)
$BtnHost.Width = 230
$BtnHost.Height = 40
$BtnHost.BackColor = "Transparent"
$BtnHost.Text = "Host: $Env:ComputerName`n`nId: $HostId"
$Form.Controls.Add($BtnHost)

# OS Version
$OSVersion = SWMB_GetOSVersionReadable
$OSColor = SWMB_GetOSVersionColor
$BtnOSVersion = New-Object System.Windows.Forms.Label
$BtnOSVersion.Location = New-Object System.Drawing.Size(30,352)
$BtnOSVersion.Width = 230
$BtnOSVersion.Height = 15
$BtnOSVersion.ForeColor = "$OSColor"
$BtnOSVersion.Text = "OS: $OSVersion"
$Form.Controls.Add($BtnOSVersion)

# Host features Frame
$BtnVersionFrame = New-Object System.Windows.Forms.GroupBox
$BtnVersionFrame.Location = New-Object System.Drawing.Size(20,240)
$BtnVersionFrame.Width = 250
$BtnVersionFrame.Height = 135
$BtnVersionFrame.Text = "Host features"
$Form.Controls.Add($BtnVersionFrame)

################################################################

# Software
$BtnSoftware = New-Object System.Windows.Forms.Button
$BtnSoftware.Location = New-Object System.Drawing.Point(300,255)
$BtnSoftware.Width = 80
$BtnSoftware.Height = 50
$BtnSoftware.Text = "View All Software"
$Form.controls.Add($BtnSoftware)
$BtnSoftware.Add_Click({
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\Tasks\View-All-Software.ps1`"" -WindowStyle Hidden
})

################################################################

# Exit
$BtnExit = New-Object System.Windows.Forms.Button
$BtnExit.Location = New-Object System.Drawing.Point(400,255)
$BtnExit.Width = 80
$BtnExit.Height = 50
$BtnExit.Text = "Exit"
$BtnExit.Add_Click({
	$Form.Close()
})
# https://learn.microsoft.com/fr-fr/dotnet/api/system.windows.media.colors
$BtnExit.BackColor = 'PaleVioletRed'
$Form.controls.Add($BtnExit)

# Main Loop
$Form.ShowDialog()
