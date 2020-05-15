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
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "dontdisplaylastusername" -Type DWord -Value 1
}

# Disable
Function DisableDontDisplayLastUsername {
	Write-Output "Afficher le dernier utilisateur..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "dontdisplaylastusername" -Type DWord -Value 0
}