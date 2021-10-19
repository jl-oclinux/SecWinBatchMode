################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2021, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
# Authors:
#  2020 - Olivier de Marchi (Grenoble INP / LEGI)
#  2020 - David Gras (CNRS / DR11)
#  2020 - Clément Deiber (CNRS / DR11)
#  2020 - Gabriel Moreau (CNRS / LEGI)
################################################################

SWMB_ImportModuleParameter (Get-PSCallStack)[0].ScriptName


################################################################
###### Les actions
################################################################

### Renommage du compte administrateur
# Configuration ordinateur / Paramètres Windows / Paramètres de sécurité / Stratégies locales / Options de sécurité
# Set
Function SetAdminAccountLogin {
	$localAdminName = get-localuser | where-object {($_.SID -like "S-1-5-21*-500")}
	Rename-LocalUser -Name $localAdminName.name -NewName $Global:SWMB_Custom.LocalAdminNameToSet -ErrorAction SilentlyContinue
}

# Unset
Function UnsetAdminAccountLogin {
	$localAdminName = get-localuser | where-object {($_.SID -like "S-1-5-21*-500")}
	Rename-LocalUser -Name $localAdminName.name -NewName $Global:SWMB_Custom.LocalAdminNameOriginal -ErrorAction SilentlyContinue
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
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name InactivityTimeoutSecs  -Type DWord -Value $Global:SWMB_Custom.InactivityTimeoutSecs -ErrorAction SilentlyContinue
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
MinimumPasswordAge = $($Global:SWMB_Custom.MinimumPasswordAge)
MaximumPasswordAge = $($Global:SWMB_Custom.MaximumPasswordAge)
MinimumPasswordLength = $($Global:SWMB_Custom.MinimumPasswordLength)
PasswordComplexity = $($Global:SWMB_Custom.PasswordComplexity)
PasswordHistorySize = $($Global:SWMB_Custom.PasswordHistorySize)
LockoutBadCount = $($Global:SWMB_Custom.LockoutBadCount)
ResetLockoutCount = $($Global:SWMB_Custom.ResetLockoutCount)
LockoutDuration = $($Global:SWMB_Custom.LockoutDuration)
EnableGuestAccount = $($Global:SWMB_Custom.EnableGuestAccount)
"

	$securityString | Out-File -FilePath $tempInfFile
	secedit /configure  /db hisecws.sdb /cfg $tempInfFile /areas SECURITYPOLICY
	Remove-Item -Path $tempInfFile
}

# Unset
Function UnsetSecurityParamAccountPolicy {
	# Nécessite un reboot
	secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb
}

################################################################

# NTP time service
# https://docs.microsoft.com/fr-fr/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings
# Set
Function SetNTPConfig {
	w32tm /register
	net start w32time
	w32tm /config /manualpeerlist: "$($Global:SWMB_Custom.NTP_ManualPeerList)"
	w32tm /config /update
	w32tm /resync
}

# Unset
Function UnsetNTPConfig {
	w32tm /unregister
	net stop w32time
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
