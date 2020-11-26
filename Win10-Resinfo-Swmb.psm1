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

################################################################
###### Exemples https://github.com/Disassembler0/Win10-Initial-Setup-Script#examples
################################################################

################################################################
###### Telemetry
################################################################

# Configuration ordinateur / Modèles d'administration / Composants Windows /Antivirus Windows Defender / MAPS / Configurer une valeur de remplacement de paramètre locale pour l'envoi de rapports à Microsoft MAPS / Desactivé
# https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsDefender::Spynet_LocalSettingOverrideSpynetReporting&Language=fr-fr
Function DisableOverrideReportingMAPS {
	Write-Output "Disabling override for reporting to Microsoft MAPS..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "LocalSettingOverrideSpynetReporting" -Type DWord -Value 0
}

# Enable
Function EnableOverrideReportingMAPS {
	Write-Output "Enabling override for reporting to Microsoft MAPS..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "LocalSettingOverrideSpynetReporting" -Type DWord -Value 1 -ErrorAction SilentlyContinue
}

# ANSSI Annexe A3
# https://getadmx.com/?Category=Windows10_Telemetry&Policy=Microsoft.Policies.Win10Privacy::DontReportInfection

Function DisableMRTReportInfectionInformation {
	Write-Output "Disable Malicious Software Reporting tool diagnostic data..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontReportInfectionInformation" -Type DWord -Value 1
}

# Enable
Function EnableMRTReportInfectionInformation {
	Write-Output "Disable Malicious Software Reporting tool diagnostic data..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontReportInfectionInformation" -ErrorAction SilentlyContinue
}




################################################################
###### User Experience
################################################################

### Désactiver les questions pour chaque nouvel utilisateur
# Computer Configuration\Administrative Templates\Windows Components\OOBE
# https://docs.microsoft.com/fr-fr/windows/client-management/mdm/policy-csp-privacy#privacy-disableprivacyexperience
# Disable
Function DisablePrivacyExperience {
	Write-Output "Disabling privacy experience from launching during user logon for new and upgraded users..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" -Name "DisablePrivacyExperience" -Type DWord -Value 1
}

# Enable
Function EnablePrivacyExperience {
	Write-Output "Enabling privacy experience from launching during user logon for new and upgraded users..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" -Name "DisablePrivacyExperience" -Type DWord -Value 0 -ErrorAction SilentlyContinue
}

################################################################

### Enregistreur d'actions utilisateur
# https://support.microsoft.com/en-us/help/22878/windows-10-record-steps
# Disable
Function DisableStepsRecorder {
	Write-Output "Disabling Windows steps recorder..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "DisableUAR" -Type DWord -Value 1
}

# Enable
Function EnableStepsRecorder {
	Write-Output "Enable Windows steps recorder..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "DisableUAR" -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Système / Gestion de la communication Internet / Paramètres de communication Internet
# ANSSI Annexe C1
# https://gpsearch.azurewebsites.net/#4723
# Disable
Function DisableDidYouKnow {
	Write-Output "Turn off Help and Support Center Did you know? content..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc" -Name "Headlines" -Type DWord -Value 1
}

# Enable
Function EnableDidYouKnow {
	Write-Output "Turn on Help and Support Center Did you know? content..."
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc" -Name "Headlines" -Type DWord -Value 0 -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Système / Gestion de la communication Internet / Paramètres de communication Internet
# ANSSI Annexe C1
# https://gpsearch.azurewebsites.net/#4754
# Disable
Function DisableHandwritingDataSharing {
	Write-Output "Turn off handwriting personalization data sharing..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\TabletPC")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\TabletPC" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\TabletPC" -Name "PreventHandwritingDataSharing" -Type DWord -Value 1
}

# Enable
Function EnableHandwritingDataSharing {
	Write-Output "Turn on handwriting personalization data sharing..."
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\TabletPC" -Name "PreventHandwritingDataSharing" -Type DWord -Value 0 -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Système / Gestion de la communication Internet / Paramètres de communication Internet
# ANSSI Annexe C1
# https://gpsearch.azurewebsites.net/#4743
# Disable
Function DisableHandwritingRecognitionErrorReporting {
	Write-Output "Turn off handwriting recognition error reporting..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports\")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports\" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports\" -Name "PreventHandwritingErrorReports" -Type DWord -Value 1
}

# Enable
Function EnableHandwritingRecognitionErrorReporting {
	Write-Output "Turn on handwriting recognition error reporting..."
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports\" -Name "PreventHandwritingErrorReports" -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Système / Gestion de la communication Internet / Paramètres de communication Internet
# ANSSI Annexe C1
# https://gpsearch.azurewebsites.net/#4727
# Disable
Function DisableWindowsErrorReporting {
	Write-Output "Turn off Windows error reporting..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports\" -Name "DoReport" -Type DWord -Value 0
}

# Enable
Function EnableWindowsErrorReporting {
	Write-Output "Turn on Windows error reporting..."
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting" -Name "DoReport" -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Composants Windows / Rapport d'erreurs Windows / Envoyer automatiquement des images mémoires pour les rapports
# key AutoApproveOSDumps
# https://getadmx.com/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsErrorReporting::WerAutoApproveOSDumps_2
# GPO Desactivé par défaut
# Disable
Function DisableOsGeneratedReport {
	Write-Output "Turn off OS-generated error reports"
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Name "AutoApproveOSDumps" -Type DWord -Value 0
}

# Enable
Function EnableOsGeneratedReport {
	Write-Output "Turn on OS-generated error reports"
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Name "AutoApproveOSDumps" -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Composants Windows / Rapport d'erreurs Windows / Ne pas envoyer des données complémentaires
# key DontSendAdditionalData
# https://getadmx.com/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsErrorReporting::WerNoSecondLevelData_2
# GPO activé par défaut
# Disable
Function DisableSendAdditionalData {
	Write-Output "Disable Error reporting Send Additional Data"
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Name "DontSendAdditionalData" -Type DWord -Value 1
}

# Enable
Function EnableSendAdditionalData {
	Write-Output "Enable Error reporting Send Additional Data"
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Name "DontSendAdditionalData" -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Panneau de Configuration / Options Regionales et Linguistiques / Personnalisation de l'écriture manuscrite / Désactiver l’apprentissage automatique / Activé
# https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.Globalization::ImplicitDataCollectionOff_2
# Disable
Function DisableAutomaticLearning {
	Write-Output "Turn off automatic learning..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\InputPersonalization")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\InputPersonalization" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
}

# Enable
Function EnableAutomaticLearning {
	Write-Output "Turn on automatic learning..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\InputPersonalization")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\InputPersonalization" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 0
}


################################################################
###### Universal Apps
################################################################

# Configuration ordinateur / Modèles d'administration / Composants Windows / WindowsStore /Afficher uniquement le magasin privé dans l'application du windows store / activé
# https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsStore::RequirePrivateStoreOnly_2&Language=fr-fr
Function DisablePrivateStoreOnly {
	Write-Output "Disable PrivateStoreOnly..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "RequirePrivateStoreOnly" -Type DWord -Value 0
}

# Enable
Function EnablePrivateStoreOnly {
	Write-Output "Enable PrivateStoreOnly..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "RequirePrivateStoreOnly" -Type DWord -Value 1
}


### Déactiver le Windows Store
# https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsStore::RemoveWindowsStore_2
# Configuration ordinateur / Modèles d'administration / Composants Windows / WindowsStore / Desactiver l'application / active
# Disable
Function DisableWindowsStore {
	Write-Output "Disable Windows Store..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "RemoveWindowsStore" -Type DWord -Value 1
}

# Enable
Function EnableWindowsStore {
	Write-Output "Enable Windows Store..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "RemoveWindowsStore" -Type DWord -Value 0
}

# Configuration ordinateur / Modèles d'administration / Composants Windows / WindowsStore / Désactiver toutes les applications du Windows Store / activé
# https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsStore::DisableStoreApps&Language=fr-fr
# Disable
Function DisableStoreApps {
	Write-Output "Disable StoreApps..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "DisableStoreApps" -Type DWord -Value 1
}

# Enable
Function EnableStoreApps {
	Write-Output "Enable StoreApps..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "DisableStoreApps" -Type DWord -Value 0
}

Function DisableAppsAccessAccount {
	Write-Output "Windows apps are not allowed to access account information..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo" -Type DWord -Value 2 -Force | Out-Null
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo_ForceDenyTheseApps" -Type MultiString -value $null -Force | Out-Null
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo_UserInControlOfTheseApps" -Type MultiString -value $null -Force | Out-Null
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo_ForceAllowTheseApps" -Type MultiString -value $null -Force | Out-Null
}

Function EnableAppsAccessAccount {
	Write-Output "Windows apps access account information not configured..."
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo_ForceDenyTheseApps" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo_UserInControlOfTheseApps" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo_ForceAllowTheseApps" -ErrorAction SilentlyContinue
}


################################################################
###### Cloud
################################################################

# Configuration Ordinateur / Paramètres Windows / Paramètres de Sécurité / Stratégies Locales / Options de sécurité / Comptes : Bloquer les comptes Microsoft /  Les utilisateurs ne peuvent pas ajouter de comptes Microsoft ni se connecter avec ces derniers
# Disable
Function DisableMicrosoftAccount {
	Write-Output "Block Microsoft Account..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoConnectedUser" -Type DWord -Value 3
}

# Enable
Function EnableMicrosoftAccount {
	Write-Output "Enable Microsoft Account..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoConnectedUser" -Type DWord -Value 0
}

################################################################
###### Cortana and search
################################################################


# Configuration ordinateur / Modèles d'administration / Composants Windows / Rechercher / Autoriser Cortona au-dessus de l'écran de verouillage / desactivé
# https://getadmx.com/?Category=Windows_10_2016&Policy=FullArmor.Policies.3B9EA2B5_A1D1_4CD5_9EDE_75B22990BC21::AllowCortanaAboveLock&Language=fr-fr
# ANSSI Annexe B1
Function DisableCortanaAboveLock {
	Write-Output "Disable Cortana AboveLock..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortanaAboveLock" -Type DWord -Value 0
}

# Enable
Function EnableCortanaAboveLock {
	Write-Output "Enable Cortana AboveLock..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortanaAboveLock" -Type DWord -Value 1
}

# Configuration ordinateur / Modèles d'administration / Composants Windows / Rechercher / Autoriser l'indexation des fichiers chiffrés / desactivé
# https://getadmx.com/?Category=Windows_10_2016&Policy=FullArmor.Policies.3B9EA2B5_A1D1_4CD5_9EDE_75B22990BC21::AllowIndexingEncryptedStoresOrItems
# ANSSI Annexe B1
Function DisableIndexingEncryptedStores {
	Write-Output "Disable IndexingEncryptedStores..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowIndexingEncryptedStoresOrItems" -Type DWord -Value 0
}

# Enable
Function EnableIndexingEncryptedStores {
	Write-Output "Allow IndexingEncryptedStores..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowIndexingEncryptedStoresOrItems" -Type DWord -Value 1
}

# Configuration ordinateur / Modèles d'administration / Composants Windows / Rechercher / Définir quelles informations sont partagées dans search / activé type => informations anonymes
# https://getadmx.com/?Category=Windows_10_2016&Policy=FullArmor.Policies.3B9EA2B5_A1D1_4CD5_9EDE_75B22990BC21::SearchPrivacy
# ANSSI Annexe B1
Function DisableSharedInformationSearch {
	Write-Output "Anonymous information is shared in Search..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "ConnectedSearchPrivacy" -Type DWord -Value 3
}

# Enable
Function EnableSharedInformationSearch {
	Write-Output "User info and location is shared in Search..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "ConnectedSearchPrivacy" -Type DWord -Value 1
}

# Configuration ordinateur / Modèles d'administration / Composants Windows / Rechercher / Ne pas effectuer des rechechers sur le web ou afficher dse résultats Web dans search / activé
# https://getadmx.com/?Category=Windows_10_2016&Policy=FullArmor.Policies.3B9EA2B5_A1D1_4CD5_9EDE_75B22990BC21::DoNotUseWebResults
# ANSSI Annexe B1
Function DisableDisplayWebResults {
	Write-Output "Don't search the web or display web results in Search..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "ConnectedSearchUseWeb" -Type DWord -Value 0
}

# Enable
Function EnableDisplayWebResults {
	Write-Output "Web results will be displayed ..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "ConnectedSearchUseWeb" -Type DWord -Value 1
}

# Windows_FW_Rules_DR11
# GPO Configuration Ordinateur / Paramètres Windows / Paramètres de sécurité / Pare-feu Windows avec sécurité avancée
# Paramètres du profil de domaine | Paramètres du profil privé | Paramètres du profil public

# Disable Firewall
Function DisableDomainProfile {
	Write-Output "Disabling Domain Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Name "EnableFirewall" -Type DWord -Value 0
}

Function DisablePrivateProfile {
	Write-Output "Disabling Private Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "EnableFirewall" -Type DWord -Value 0
}

Function DisablePublicProfile {
	Write-Output "Disabling Public Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"{
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Name "EnableFirewall" -Type DWord -Value 0
}

# Enable Firewall
Function EnableDomainProfile {
	Write-Output "Enabling Domain Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"{
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Name "EnableFirewall" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Name "DefaultInboundAction" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Name "DefaultOutboundAction" -Type DWord -Value 0
}

Function EnablePrivateProfile {
	Write-Output "Enabling Private Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile"{
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "EnableFirewall" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "DefaultInboundAction" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "DefaultOutboundAction" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "DoNotAllowExceptions" -Type DWord -Value 1
}

Function EnablePublicProfile {
	Write-Output "Enabling Public Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"{
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Name "EnableFirewall" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Name "DefaultInboundAction" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Name "DefaultOutboundAction" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Name "AllowLocalPolicyMerge" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Name "AllowLocalIPsecPolicyMerge" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Name "DisableNotifications" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Name "DoNotAllowExceptions" -Type DWord -Value 1
}


# Export functions
Export-ModuleMember -Function *
