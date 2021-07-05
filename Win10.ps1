##########
# Win 10 / Server 2016 / Server 2019 Initial Setup Script - Main execution loop
# Author: Disassembler <disassembler@dasm.cz>
# Version: v3.10, 2020-07-15
# Source: https://github.com/Disassembler0/Win10-Initial-Setup-Script
##########

# Relaunch the script with administrator privileges
Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $Global:SWMB_PSCommandArgs" -Verb RunAs
		Exit
	}
}

$Script:SWMB_CheckTweak = $False

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
		Resolve-Path $args[++$i] -ErrorAction Stop | ForEach-Object {
			$include = $_.Path
			$Global:SWMB_PSCommandArgs += "-include `"$include`""
			# Import the included file as a module
			Import-Module -Name $include -ErrorAction Stop
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
		# Resolve full path to the output file
		$log = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($args[++$i])
		$Global:SWMB_PSCommandArgs += "-log `"$log`""
		# Record session to the output file
		Start-Transcript $log
	} ElseIf ($args[$i].ToLower() -eq "-check") {
		$Script:SWMB_CheckTweak = $True
	} Else {
		$Global:SWMB_PSCommandArgs += $args[$i]
		# Load tweak names from command line
		SWMB_AddOrRemoveTweak($args[$i])
	}
	$i++
}

If ($Script:SWMB_CheckTweak) {
	# Only check for multiple same tweak
	SWMB_CheckTweaks
} Else {
	# Call the desired tweak functions
	SWMB_RunTweaks
}
