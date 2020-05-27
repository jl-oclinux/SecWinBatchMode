################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb
# Authors:
#  2020 - Olivier de Marchi (Grenoble INP / LEGI)
#  2020 - David Gras (CNRS / DR11)
#  2020 - Clément Deiber (CNRS / DR11)
#  2020 - Gabriel Moreau (CNRS / LEGI)
################################################################

#$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
#$ScriptDirPre = $ScriptDir+"\Win10-MyVar-Pre-swmb.psm1"
#Import-Module -name $ScriptDirPre
#
##Si le fichier personnel de définition de variable existe, on ajoute le module*
#$ScriptDirPost = ScriptDir+"\Win10-MyVar-Post-swmb.psm1"
#if (Test-Path ScriptDirPost) {
#   Import-Module -name $ScriptDirPost
#}

$myScriptName = (Get-PSCallStack)[0].ScriptName
$myScriptFullPathBasename = (Get-Item $myScriptName).DirectoryName + (Get-Item $MyScriptName).Basename
$myScriptVarDefault = $myScriptFullPathBasename + '-VarDefault.psm1'
Import-Module -Name $myScriptVarDefault

# Si le fichier personnel de définition de variable existe, on ajoute le module*
$myScriptVarOverload = $myScriptFullPathBasename + '-VarOverload.psm1'
if (Test-Path $myScriptVarOverload) {
	Import-Module -Name $myScriptVarOverload
}



###############################################
# Les actions
################################################
# Renommage du compte administrateur
# Configuration ordinateur / Paramètres Windows / Paramètres de sécurité / Stratégies locales / Options de sécurité
# Enable
Function EnableRenameAdminAccount {
	$localAdminName = get-localuser | where-object {($_.SID -like "S-1-5-21*-500")}
	Rename-LocalUser -Name $localAdminName.name -NewName $myLocalAdminNameToSet -ErrorAction SilentlyContinue
}

# Disable
Function DisableRenameAdminAccount {
	$localAdminName = get-localuser | where-object {($_.SID -like "S-1-5-21*-500")}
	Rename-LocalUser -Name $localAdminName.name -NewName $myLocalAdminNameOriginal -ErrorAction SilentlyContinue
}

# Ne pas afficher le nom du dernier utilisateur
# Enable
Function EnableDontDisplayLastUsername {
	Write-Output "Ne pas afficher le dernier utilisateur..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "dontdisplaylastusername" -Type DWord -Value 1 -ErrorAction SilentlyContinue
}

# Disable
Function DisableDontDisplayLastUsername {
	Write-Output "Afficher le dernier utilisateur..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "dontdisplaylastusername" -Type DWord -Value 0 -ErrorAction SilentlyContinue
}

# Verrouillage de la session : timeout de session
# Enable
Function EnableSessionLockTimeout {
	Write-Output "Définition du timeout de session..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name $myInactivityTimeoutSecs -Type DWord -Value $InactivityTimeoutSecs -ErrorAction SilentlyContinue
}

# Disable
Function DisableSessionLockTimeout {
	Write-Output "Suppression du timeout de session..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name $myInactivityTimeoutSecs -Type DWord -Value 0 -ErrorAction SilentlyContinue
}
