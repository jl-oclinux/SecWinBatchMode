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


Function ImportModuleParameter() {
	Param (
		[Parameter(Mandatory = $true)] [string]$moduleScriptName
	)

	$moduleScriptPath = (Get-Item $moduleScriptName).DirectoryName
	$moduleScriptBasename = (Get-Item $moduleScriptName).Basename
	$moduleScriptFullPathBasename = Join-Path -Path $moduleScriptPath -ChildPath $moduleScriptBasename
	$moduleScriptVarDefault = $moduleScriptFullPathBasename + '-VarDefault.psm1'
	Import-Module -Name $moduleScriptVarDefault

	# Si le fichier personnel de définition de variable existe, on ajoute le module ayant l'extension -VarOverload
	$moduleScriptVarOverload1 = $moduleScriptFullPathBasename + '-VarOverload.psm1'
	if (Test-Path $moduleScriptVarOverload1) {
		Import-Module -Name $moduleScriptVarOverload1
	}
	# Idem si le module est dans le dossier parent
	$moduleScriptVarOverload2 = (Join-Path $moduleScriptPath ".." ".."  ".." "Modules" $moduleScriptBasename) + '-VarOverload.psm1'
	if (Test-Path $moduleScriptVarOverload2) {
		Import-Module -Name $moduleScriptVarOverload2
	}
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function ImportModuleParameter
