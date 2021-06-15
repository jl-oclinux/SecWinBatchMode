################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2021, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb
# Authors:
#  2020 - Olivier de Marchi (Grenoble INP / LEGI)
#  2020 - David Gras (CNRS / DR11)
#  2020 - Clément Deiber (CNRS / DR11)
#  2020 - Gabriel Moreau (CNRS / LEGI)
################################################################


################################################################
### Region Auxiliary Functions
################################################################

# Write message separator
$Script:SWMB_MsgCount = 0

Function SysMsg {
	$Script:SWMB_MsgCount++
	Write-Host "Message separator " $Script:SWMB_MsgCount
}

################################################################

# Wait for key press
Function SysPause {
	Write-Output "`nPress any key to continue..."
	[Console]::ReadKey($true) | Out-Null
}

################################################################

# Halt computer
Function SysHalt {
	Write-Output "Shutdown now..."
	Stop-Computer -ComputerName localhost -Force
}

################################################################

# Restart computer
Function SysRestart {
	Write-Output "Restarting..."
	Restart-Computer
}

################################################################

# Implementation used in powershell script
# The main implementation in Win10.ps1 is used otherwise in the CLI
Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Write-Host "You must run this script with administrator privileges"
		Exit
	}
}


################################################################
### Region Internal Functions
################################################################

Function SWMB_AddOrRemoveTweak() {
	Param (
		[string]$tweak
	)

	If ($tweak[0] -eq "!") {
		# If the name starts with exclamation mark (!), exclude the tweak from selection
		$Global:SWMB_Tweaks = $Global:SWMB_Tweaks | Where-Object { $_ -ne $tweak.Substring(1) }
	} ElseIf ($tweak -ne "") {
		# Otherwise add the tweak
		$Global:SWMB_Tweaks += $tweak
	}
}

################################################################

Function SWMB_ImportModuleParameter() {
	Param (
		[Parameter(Mandatory = $true)] [string]$moduleScriptName
	)

	$moduleScriptPath = (Get-Item $moduleScriptName).DirectoryName
	$moduleScriptBasename = (Get-Item $moduleScriptName).Basename

	# Try to load default parameter module with extension -VarDefault
	$moduleScriptVarDefault = (Join-Path -Path $moduleScriptPath -ChildPath $moduleScriptBasename) + '-VarDefault.psm1'
	If (Test-Path -LiteralPath $moduleScriptVarDefault) {
		Import-Module -Name $moduleScriptVarDefault -ErrorAction Stop
	}

	# Try to load local overload parameter module with extension -VarOverload
	While (Test-Path -LiteralPath $moduleScriptPath) {
		# Module VarOverload directly in the current folder
		$moduleScriptVarOverload1 = (Join-Path -Path $moduleScriptPath -ChildPath $moduleScriptBasename) + '-VarOverload.psm1'
		If (Test-Path -LiteralPath $moduleScriptVarOverload1) {
			Import-Module -Name $moduleScriptVarOverload1 -ErrorAction Stop
			Break
		}
		# Or module VarOverload directly in the subfolder Modules
		$moduleScriptVarOverload2 = (Join-Path -Path $moduleScriptPath -ChildPath (Join-Path -Path "Modules" -ChildPath $moduleScriptBasename)) + '-VarOverload.psm1'
		If (Test-Path -LiteralPath $moduleScriptVarOverload2) {
			Import-Module -Name $moduleScriptVarOverload2 -ErrorAction Stop
			Break
		}

		# Search module in the parent folder .. and so on
		$newPath = (Resolve-Path (Join-Path -Path $moduleScriptPath -ChildPath "..") -ErrorAction SilentlyContinue) 
		If ("$newPath" -eq "$moduleScriptPath") {
			Break
		}
		$moduleScriptPath = $newPath
	}
}

################################################################

Function SWMB_CheckTweaks {
	$uniqueTweak = @{}

	ForEach ($tweak in $Global:SWMB_Tweaks) {
		# Test if tweak function really exists
		If (-not(Get-Command -Name $tweak -ErrorAction SilentlyContinue)) {
			Write-Host "Tweak $tweak is not defined!"
		}

		# Push tweak in a hash table
		$key = $tweak -Replace '^(Enable|Disable|Install|Uninstall|Show|Hide|Add|Remove|Set|Unset|Pin|Unpin)',''
		$uniqueTweak[$key]++
	}

	ForEach ($tweak in $uniqueTweak.keys) {
		If ($uniqueTweak[$tweak] -eq 1) {
			Continue
		}
		$message = "Tweak {0} is defined {1} times!" -f $tweak, $uniqueTweak[$tweak]
		Write-Host $message
	}
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
