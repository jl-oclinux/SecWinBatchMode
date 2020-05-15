$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$ScriptDir += "\swmb-var-local.psm1"
Import-Module -name $ScriptDir -verbose

#Renommage du compte administrateur
#Configuration ordinateur/Paramètres Windows/Paramètres de sécurité/stratégies locales/Options de sécurité
#Enable
EnableRenameAdminAccount {
   $localAdminName = get-localuser |  where-object {($_.SID -like "S-1-5-21*-500")}
   Rename-LocalUser -Name $localAdminName.name -NewName $localAdminNameToSet -ErrorAction SilentlyContinue
}

#Disable
DisableRenameAdminAccount {
   $localAdminName = get-localuser |  where-object {($_.SID -like "S-1-5-21*-500")}
   Rename-LocalUser -Name $localAdminName.name -NewName $administrateur -ErrorAction SilentlyContinue
}

#ne pas afficher le nom du dernier utilisateur
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

#verrouillage de la session : timeout de session
# Enable
Function EnableSessionLock {
	Write-Output "Définition du timeout de session..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "dontdisplaylastusername" -Type DWord -Value 1 -ErrorAction SilentlyContinue
}

# Disable
Function DisableSessionLock{
	Write-Output "Définition du timeout de session..."
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "dontdisplaylastusername" -Type DWord -Value 0 -ErrorAction SilentlyContinue
}

#Ne pas afficher le nom du dernier utilisateur
# Enable
Function EnableDontDisplayLastUsername {
	Write-Output "Ne pas afficher le dernier utilisateur..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "InactivityTimeoutSecs" -Type DWord -Value $localSessionTimeout -ErrorAction SilentlyContinue
}

# Disable
Function DisableDontDisplayLastUsername {
	Write-Output "Afficher le dernier utilisateur..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "InactivityTimeoutSecs" -Type DWord -Value 0
}