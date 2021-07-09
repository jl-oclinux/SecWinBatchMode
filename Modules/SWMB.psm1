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

Function SysAutoUpgrade {
	$moduleScriptPath = (Get-Item (Get-PSCallStack)[0].ScriptName).DirectoryName
	$swmbCorePath = (Resolve-Path (Join-Path -Path $moduleScriptPath -ChildPath '..') -ErrorAction SilentlyContinue)

	$gitUrl = 'https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb/-/archive/master/resinfo-swmb-master.zip'
	$tmpFolder = (Join-Path -Path $Env:SystemDrive -ChildPath "SWMB-$(New-Guid)")
	If ($Env:Temp -ne '') {
		$tmpFolder = (Join-Path -Path $Env:Temp -ChildPath "SWMB-$(New-Guid)")
	}
	New-Item -Path $tmpFolder -ItemType Directory | Out-Null

	$outZipFile = (Join-Path -Path $tmpFolder -ChildPath swmb-bitlocker.zip)

	Invoke-WebRequest -Uri $gitUrl -OutFile $outZipFile -ErrorAction SilentlyContinue
	Expand-Archive -Path $outZipFile -DestinationPath $tmpFolder
	If (Test-Path "$tmpFolder\resinfo-swmb-master") {
		Write-Host "Upgrade of SMWB installation..."
		Copy-Item -Path "$tmpFolder\resinfo-swmb-master\*" -Destination "$swmbCorePath" -Recurse -Force
		Get-ChildItem -Path "$swmbCorePath" -Recurse  | Unblock-File
	} Else {
		Write-Host "Error: Upgrade of SMWB impossible..."
	}

	if (Test-Path "$tmpFolder") {
		Remove-Item -Path "$tmpFolder" -Force -Recurse -ErrorAction SilentlyContinue
	}
}

################################################################
### Obsolete function
################################################################

# Wait for key press
Function WaitForKey {
	Write-Output "Warning: obsolete tweak, now use SysPause"
	Write-Output "`nPress any key to continue..."
	[Console]::ReadKey($true) | Out-Null
}

################################################################

# Restart computer
Function Restart {
	Write-Output "Warning: obsolete tweak, now use SysRestart"
	Write-Output "Restarting..."
	Restart-Computer
}

################################################################
### Region Internal Functions
################################################################

Function SWMB_Init {
	$Global:SWMB_Tweaks = @()
	$Global:SWMB_PSCommandArgs = @()
}

################################################################

Function SWMB_AddOrRemoveTweak() {
	Param (
		[string]$Tweak,
		[string]$Path = '.'
	)

	If ($Tweak[0] -eq "!") {
		# If the name starts with exclamation mark (!), exclude the tweak from selection
		$Global:SWMB_Tweaks = $Global:SWMB_Tweaks | Where-Object { $_ -ne $Tweak.Substring(1) }
	} ElseIf ($Tweak -cmatch '^\$INCLUDE\s+[^\s]') {
		# Include preset file
		$file = (Join-Path -Path $Path -ChildPath ($Tweak -creplace '^\$INCLUDE\s+([^\s])', '$1'))
		SWMB_LoadTweakFile -TweakFile "$file" -CLI $False
	} ElseIf ($Tweak -ne "") {
		# Otherwise add the tweak
		$Global:SWMB_Tweaks += $Tweak
	}
}

################################################################

Function SWMB_LoadTweakFile() {
	Param (
		[string]$TweakFile,
		[bool]$CLI = $True
	)

	# Resolve full path to the preset file
	Resolve-Path $TweakFile -ErrorAction Stop | ForEach-Object {
		$preset = $_.Path
		$path = (Split-Path -Path $_)
		# Bluid CLI for RequireAdmin
		If ($CLI -eq $True) {
			$Global:SWMB_PSCommandArgs += "-preset `"$preset`""
		}
		# Load tweak names from the preset file
		Get-Content $preset -ErrorAction Stop | ForEach-Object {
			SWMB_AddOrRemoveTweak -Tweak $_.Split("#")[0].Trim() -Path $path
		}
	}
}

################################################################

Function SWMB_RunTweaks {
	$Global:SWMB_Tweaks | ForEach-Object {
		Invoke-Expression $_
	}
}

################################################################

Function SWMB_ImportModuleParameter() {
	Param (
		[Parameter(Mandatory = $true)] [string]$moduleScriptName
	)

	Function _ModuleAutoLoad() {
		Param (
			[Parameter(Mandatory = $true)] [string]$PathBase
		)

		$VarOverload = $PathBase + '-VarOverload.psm1'
		$VarAutodel  = $PathBase + '-VarAutodel.psm1'

		If ((Test-Path -LiteralPath $VarOverload) -Or (Test-Path -LiteralPath $VarAutodel)) {
			If (Test-Path -LiteralPath $VarOverload) {
				Import-Module -Name $VarOverload -ErrorAction Stop
			}
			If (Test-Path -LiteralPath $VarAutodel) {
				Import-Module -Name $VarAutodel -ErrorAction Stop
				Remove-Item $VarAutodel -ErrorAction Stop
			}
			return $true
		}
		return $false
	}

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
		If (_ModuleAutoLoad -PathBase (Join-Path -Path $moduleScriptPath -ChildPath $moduleScriptBasename)) {
			Break
		}

		# Or module VarOverload directly in the subfolder Modules
		If (_ModuleAutoLoad -PathBase (Join-Path -Path $moduleScriptPath -ChildPath (Join-Path -Path "Modules" -ChildPath $moduleScriptBasename))) {
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
