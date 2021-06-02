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

Function AddOrRemoveTweak() {
	Param (
		[Parameter(Mandatory = $true)] [string]$tweak
	)

	If ($tweak[0] -eq "!") {
		# If the name starts with exclamation mark (!), exclude the tweak from selection
		$Global:tweaks = $Global:tweaks | Where-Object { $_ -ne $tweak.Substring(1) }
	} ElseIf ($tweak -ne "") {
		# Otherwise add the tweak
		$Global:tweaks += $tweak
	}
}

################################################################

Function ImportModuleParameter() {
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
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
