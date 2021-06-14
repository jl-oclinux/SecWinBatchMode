##########
# Win 10 / Server 2016 / Server 2019 Initial Setup Script - Main execution loop
# Author: Disassembler <disassembler@dasm.cz>
# Version: v3.10, 2020-07-15
# Source: https://github.com/Disassembler0/Win10-Initial-Setup-Script
##########

# Relaunch the script with administrator privileges
Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -Verb RunAs
		Exit
	}
}

$Global:tweaks = @()
$PSCommandArgs = @()
$checkTweak = $False

# First argument
$i = 0

# Load default SWMB modules or just core functions
$SwmbPath = (Get-Item (Get-PSCallStack)[0].ScriptName).DirectoryName
$SwmbModule = (Join-Path -Path "$SwmbPath" -ChildPath (Join-Path -Path "Modules" -ChildPath "SWMB.psd1"))
If (($args.Length -gt 0) -And ($args[$i].ToLower() -eq "-core")) {
	$SwmbModule = (Join-Path -Path "$SwmbPath" -ChildPath (Join-Path -Path "Modules" -ChildPath "SWMB.psm1"))
	$i++
}
If (Test-Path $SwmbModule) {
	Import-Module -Name $SwmbModule -ErrorAction Stop
}

# Parse and resolve paths in passed arguments
While ($i -lt $args.Length) {
	If ($args[$i].ToLower() -eq "-include") {
		# Resolve full path to the included file
		# Wilcard support
		Resolve-Path $args[++$i] -ErrorAction Stop | ForEach-Object {
			$include = $_.Path
			$PSCommandArgs += "-include `"$include`""
			# Import the included file as a module
			Import-Module -Name $include -ErrorAction Stop
		}
	} ElseIf ($args[$i].ToLower() -eq "-preset") {
		# Resolve full path to the preset file
		Resolve-Path $args[++$i] -ErrorAction Stop | ForEach-Object {
			$preset = $_.Path
			$PSCommandArgs += "-preset `"$preset`""
			# Load tweak names from the preset file
			Get-Content $preset -ErrorAction Stop | ForEach-Object { AddOrRemoveTweak($_.Split("#")[0].Trim()) }
		}
	} ElseIf ($args[$i].ToLower() -eq "-log") {
		# Resolve full path to the output file
		$log = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($args[++$i])
		$PSCommandArgs += "-log `"$log`""
		# Record session to the output file
		Start-Transcript $log
	} ElseIf ($args[$i].ToLower() -eq "-check") {
		$checkTweak = $True
	} Else {
		$PSCommandArgs += $args[$i]
		# Load tweak names from command line
		AddOrRemoveTweak($args[$i])
	}
	$i++
}

If ($checkTweak) {
	# Only check for multiple same tweak
	CheckTweaks
} Else {
	# Call the desired tweak functions
	$Global:tweaks | ForEach-Object { Invoke-Expression $_ }
}
