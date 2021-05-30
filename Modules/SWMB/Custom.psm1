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

$myScriptName = (Get-PSCallStack)[0].ScriptName
$myScriptFullPathBasename = (Get-Item $myScriptName).DirectoryName + + '\' + (Get-Item $MyScriptName).Basename
$myScriptVarDefault = $myScriptFullPathBasename + '-VarDefault.psm1'
Import-Module -Name $myScriptVarDefault

# Si le fichier personnel de définition de variable existe, on ajoute le module*
$myScriptVarOverload = $myScriptFullPathBasename + '-VarOverload.psm1'
if (Test-Path $myScriptVarOverload) {
	Import-Module -Name $myScriptVarOverload
}


################################################################
###### Les actions
################################################################

### Renommage du compte administrateur
# Configuration ordinateur / Paramètres Windows / Paramètres de sécurité / Stratégies locales / Options de sécurité
# Enable
Function SetAdminAccountLogin {
	$localAdminName = get-localuser | where-object {($_.SID -like "S-1-5-21*-500")}
	Rename-LocalUser -Name $localAdminName.name -NewName $myLocalAdminNameToSet -ErrorAction SilentlyContinue
}

# Disable
Function UnsetAdminAccountLogin {
	$localAdminName = get-localuser | where-object {($_.SID -like "S-1-5-21*-500")}
	Rename-LocalUser -Name $localAdminName.name -NewName $myLocalAdminNameOriginal -ErrorAction SilentlyContinue
}

################################################################

### Ne pas afficher le nom du dernier utilisateur
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

################################################################

### Verrouillage de la session : timeout de session
# Enable
Function EnableSessionLockTimeout {
	Write-Output "Définition du timeout de session..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name InactivityTimeoutSecs  -Type DWord -Value $myInactivityTimeoutSecs -ErrorAction SilentlyContinue
}

# Disable
Function DisableSessionLockTimeout {
	Write-Output "Suppression du timeout de session..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name InactivityTimeoutSecs  -Type DWord -Value 0 -ErrorAction SilentlyContinue
}

################################################################



################################################################

### Application de paramètres de sécurité
# cf : https://www.itninja.com/blog/view/using-secedit-to-apply-security-templates
# Configuration ordinateur / Paramètres Windows / Paramètres de sécurité / Stratégie de comptes / Stratégie de mots de passe
# Set
Function SetSecurityParamAccountPolicy {
	$tempFile = New-TemporaryFile
	$tempInfFile = "$tempFile.inf"


	Rename-Item -Path $tempFile.FullName -NewName $tempInfFile
	
	$securityString = "[Unicode]
	Unicode=yes
	[Version]
	signature=`"`$CHICAGO`$`"
	Revision=10
	[System Access]
	MinimumPasswordAge = $MinimumPasswordAge
	MaximumPasswordAge = $MaximumPasswordAge
	MinimumPasswordLength = $MinimumPasswordLength
	PasswordComplexity = $PasswordComplexity
	PasswordHistorySize = $PasswordHistorySize
	LockoutBadCount = $LockoutBadCount
	ResetLockoutCount = $ResetLockoutCount
	LockoutDuration = $LockoutDuration
	EnableGuestAccount = $EnableGuestAccount
	"
	$securityString | Out-File -FilePath $tempInfFile
	secedit /configure  /db hisecws.sdb /cfg $tempInfFile /areas SECURITYPOLICY
	Remove-Item -Path $tempInfFile
}

# UnSet
Function UnSetSecurityParamAccountPolicy {
	# Nécessite un reboot
	secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb
}

################################################################
