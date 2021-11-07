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

# Relaunch the script with administrator privileges
Function SysRequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $Global:SWMB_PSCommandArgs" -Verb RunAs
		Exit
	}
}

$Script:SWMB_CheckTweak = 'Run'
$Script:SWMB_Log        = ''
$Script:SWMB_Hash       = ''

# First argument
$i = 0

# Load default SWMB modules or just core functions
$SwmbCorePath = (Get-Item (Get-PSCallStack)[0].ScriptName).DirectoryName
$SwmbCoreModule = (Join-Path -Path "$SwmbCorePath" -ChildPath (Join-Path -Path "Modules" -ChildPath "SWMB.psd1"))
If (($args.Length -gt 0) -And ($args[$i].ToLower() -eq "-core")) {
	$SwmbCoreModule = (Join-Path -Path "$SwmbCorePath" -ChildPath (Join-Path -Path "Modules" -ChildPath "SWMB.psm1"))
	$i++
}
If (Test-Path $SwmbCoreModule) {
	Import-Module -Name $SwmbCoreModule -ErrorAction Stop
}

SWMB_Init

# Parse and resolve paths in passed arguments
While ($i -lt $args.Length) {
	If ($args[$i].ToLower() -eq "-include") {
		# Resolve full path to the included file
		# Wilcard support
		Write-Output "Warning: obsolete command line argument -include, now use -import"
		Resolve-Path $args[++$i] -ErrorAction Stop | ForEach-Object {
			$include = $_.Path
			$Global:SWMB_PSCommandArgs += "-import `"$include`""
			# Import the included file as a module
			Import-Module -Name $include -ErrorAction Stop
		}
	} ElseIf ($args[$i].ToLower() -eq "-import") {
		# Resolve full path to the imported module file
		# Wilcard support
		Resolve-Path $args[++$i] -ErrorAction Stop | ForEach-Object {
			$import = $_.Path
			$Global:SWMB_PSCommandArgs += "-import `"$import`""
			# Import the imported file as a module
			Import-Module -Name $import -ErrorAction Stop
		}
	} ElseIf ($args[$i].ToLower() -eq "-exp") {
		$experimental = (Join-Path -Path "$SwmbCorePath" -ChildPath (Join-Path -Path "Modules" (Join-Path -Path "SWMB" -ChildPath "Experimental.psm1")))
		If (Test-Path $experimental) {
			Import-Module -Name $experimental -ErrorAction Stop
		}
	} ElseIf ($args[$i].ToLower() -eq "-preset") {
		# Load tweak preset file
		SWMB_LoadTweakFile($args[++$i])
	} ElseIf ($args[$i].ToLower() -eq "-log") {
		If ([string]::IsNullOrEmpty($Script:SWMB_Log)) {
			# Resolve full path to the output file
			$Script:SWMB_Log = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($args[++$i])
			$Global:SWMB_PSCommandArgs += "-log `"$Script:SWMB_Log`""
			# Record session to the output file
			Start-Transcript -Path $Script:SWMB_Log
		} Else {
			Write-Error -Message "SWMB support only one -log command line option" -ErrorAction Stop
		}
	} ElseIf ($args[$i].ToLower() -eq "-hash") {
		If ([string]::IsNullOrEmpty($Script:SWMB_Hash)) {
			# Resolve full path to the hash file
			$Script:SWMB_Hash = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($args[++$i])
			$Global:SWMB_PSCommandArgs += "-hash `"$Script:SWMB_Hash`""
		} Else {
			Write-Error -Message "SWMB support only one -hash command line option" -ErrorAction Stop
		}
	} ElseIf ($args[$i].ToLower() -eq "-check") {
		$Script:SWMB_CheckTweak = 'Check'
	} ElseIf ($args[$i].ToLower() -eq "-print") {
		$Script:SWMB_CheckTweak = 'Print'
	} Else {
		$Global:SWMB_PSCommandArgs += $args[$i]
		# Load tweak names from command line
		SWMB_AddOrRemoveTweak($args[$i])
	}
	$i++
}

Switch ($Script:SWMB_CheckTweak) {
	'Check' {
		# Only check for multiple same tweak
		SWMB_CheckTweaks
		}
	'Run' {
		# Call the desired tweak functions
		If ($Script:SWMB_Hash -ne '') {
			SWMB_MakeCkeckpoint -Path $Script:SWMB_Hash
		}
		SWMB_RunTweaks
		}
	'Print' {
		# Call the desired tweak functions
		SWMB_PrintTweaks
		}
}

If (-not ([string]::IsNullOrEmpty($Script:SWMB_Log))) {
	Stop-Transcript
}
