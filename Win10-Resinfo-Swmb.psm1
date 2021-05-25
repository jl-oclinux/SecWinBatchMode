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

<#
.NOTES
Project    : CNRS RESINFO SWMB
Copyright  : (C) 2020, CNRS, France
License    : MIT License (Same as project Win10-Initial-Setup-Script)
Version    : 0.8.0
Author     : 2020 - Olivier de Marchi (Grenoble INP / LEGI)
Author     : 2020 - David Gras (CNRS / DR11)
Author     : 2020 - Clément Deiber (CNRS / DR11)
Author     : 2020 - Gabriel Moreau (CNRS / LEGI)
Created on : 2020-04-21
GUID       : 862ac9b1-a77b-408f-ae49-0dd500561860
#>


@{
	ModuleName = 'RESINFO-SWMB';
	ModuleVersion = "0.8.0";
	GUID = "862ac9b1-a77b-408f-ae49-0dd500561860";
}

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

# Windows Hello Authentification
# https://answers.microsoft.com/en-us/windows/forum/windows_10-hello/how-to-disable-windows-hello/05ab5492-19c7-4d44-b762-d93b44a9cf65
# https://www.minitool.com/news/disable-windows-hello.html
# Computer Configuration -> Administrative Templates -> System -> Logon : Turn on PIN sign-in and select Disabled.
# Disable
Function DisableWindowsHello {
	Write-Output "Block Windows Hello Authentification..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions" -Name "value" -Type DWord -Value 0
}

# Enable
Function EnableWindowsHello {
	Write-Output "Enable Windows Hello Authentification..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions" -Name "value" -Type DWord -Value 1
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
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Name "EnableFirewall" -Type DWord -Value 0
}

# Enable Firewall
Function EnableDomainProfile {
	Write-Output "Enabling Domain Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Name "EnableFirewall" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Name "DefaultInboundAction" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Name "DefaultOutboundAction" -Type DWord -Value 0
}

Function EnablePrivateProfile {
	Write-Output "Enabling Private Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "EnableFirewall" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "DefaultInboundAction" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "DefaultOutboundAction" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "DoNotAllowExceptions" -Type DWord -Value 1
}

Function EnablePublicProfile {
	Write-Output "Enabling Public Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile")) {
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

# Turn off hybrid sleep
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.PowerManagement::DCStandbyWithHiberfileEnable_2
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.PowerManagement::ACStandbyWithHiberfileEnable_2
# Disable
Function DisableHybridSleep {
	Write-Output "Turn off hybrid sleep (plugged in and battery)..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e" -Name "ACSettingIndex" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e" -Name "DCSettingIndex" -Type DWord -Value 0
}

# Enable
Function EnableHybridSleep {
	Write-Output "Turn on hybrid sleep (plugged in and battery)..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e" -Name "ACSettingIndex" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e" -Name "DCSettingIndex" -Type DWord -Value 1
}


################################################################
###### Crypt Bitlocker
################################################################

# Enable
Function EnableBitlocker {
	## PowerShell bitlocker commands
	# https://docs.microsoft.com/en-us/powershell/module/bitlocker/?view=win10-ps

	Function _NetworkKeyBackup() {
		Param (
			[Parameter(Mandatory = $true)] [string]$wantToSave
		)

		If ($wantToSave -eq $false) {
			$isNetWorkBackup = Read-Host -Prompt "Do you want to save recovery keys on a network drive? [y/N]"
			If ($isNetWorkBackup -ne "y") {
				return $null
			}
		}

		Do {
			$networkKeyBackup = Read-Host -Prompt "Provide a CIFS/SMB writable network path with UNC syntax \\serverName\SharedFolder"
		} until (($networkKeyBackup.Length -gt 2) -and ("\\" -ccontains $networkKeyBackup.Substring(0, 2)))

		If ($networkKeyBackup.Substring($networkKeyBackup.Length - 1) -ne "\") {
			$networkKeyBackup += "\"
		}
		Try {
			New-Item -Name isWriteAllowed.txt -ItemType File -Path $networkKeyBackup -Force -ErrorAction stop | Out-Null
			return $networkKeyBackup
			# Todo question : do I delete the file afterwards?
		}
		Catch {
			Write-Host ("$networkKeyBackup is not writable! Choose another location!") -ForegroundColor Red
			_NetworkKeyBackup -wantToSave $true
		}
	}

	Function _DecryptAndWait ([string]$letter) {
		Disable-BitLocker -MountPoint $letter
		Write-Host "decryption in progress for $letter"
		While ((Get-BitLockerVolume -MountPoint $letter).EncryptionPercentage -gt 0 ) {
			Start-Sleep -Seconds 20
		}
		Write-Host "$letter is fully decrypted"
	}

	Function _EncryptSytemDrive() {
		param (
			[string]$networkKeyBackupFolder
		)
		#$title = 'Activation bitlocker'
		#$query = 'Do you want to use PIN?'
		#$choices = '&Yes', '&No'
		#$decision = $Host.UI.PromptForChoice($title, $query, $choices, 1)
		$useCodePin = Read-Host -Prompt "Activation bitlocker - Do you want to use PIN code? [Y/n]"
		If ($useCodePin -ne "n") {
			$secure = Read-Host -AsSecureString -Prompt "Code PIN (6 digits)"
			Write-Host "Enable bitlocker on system drive $systemDrive with PIN code"
			Enable-BitLocker -MountPoint "$systemDrive" -TpmAndPinProtector -Pin $secure -EncryptionMethod "XtsAes256" 3> $null
			Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 2 `
				-Message "SWMB: Enable bitlocker on system drive $systemDrive with PIN code"
		}
		Else {
			Write-Host "Enable bitlocker on system drive $systemDrive without PIN code"
			Enable-BitLocker -MountPoint "$systemDrive" -TpmProtector -EncryptionMethod "XtsAes256"
			Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 3 `
				-Message "SWMB: Enable bitlocker on system drive $systemDrive without PIN code"
		}

		Write-Host "Add system drive key"
		Add-BitLockerKeyProtector -MountPoint "$systemDrive" -RecoveryPasswordProtector
		Write-Host "Copy system drive key on $systemDrive"
		$pathKey = $systemDrive + "\" + $Env:ComputerName + "-bitlockerRecoveryKey-" + $dateNow + "-" + $systemDriveLetter + ".txt"
		If (Test-Path -Path $pathKey -PathType leaf) {
			$oldKey = $systemDrive + "\" + $Env:ComputerName + "-bitlockerRecoveryKey-" + $dateNow + "-" + $systemDriveLetter + ".txt.old"
			Write-Host "Warning: $pathKey already exist => rename with .old extension"
			If (Test-Path -Path $oldKey -PathType leaf) {
				Write-Host "Warning: delete before old key $oldKey"
				Remove-Item -Path $oldKey -Force
			}
			Rename-Item -Path $pathKey -NewName $oldKey
		}
		(Get-BitLockerVolume -MountPoint $systemDriveLetter).KeyProtector > $pathKey
		# acl on key see https://stackoverflow.com/a/43317244
		icacls.exe $pathKey /Reset
		icacls.exe $pathKey /Grant:r "$((Get-Acl -Path $pathKey).Owner):(R)"
		icacls.exe $pathKey /InheritanceLevel:r

		# copy key if $networkKeyBackup
		If (-not ([string]::IsNullOrEmpty($networkKeyBackupFolder))) {
			Try {
				Copy-Item $pathKey -Destination $networkKeyBackupFolder -ErrorAction Continue
			}
			Catch {
				$message = "Error backuping $pathKey on network folder $networkKeyBackupFolder"
				Write-Host $message
				Write-EventLog -LogName Application -Source "SWMB" -EntryType Warning -EventID 4 -Message $message
			}
		}
	}

	# We treat all partitions that have an associated letter and that are of type fixed
	# ie we don't take into account the usb keys
	Function _EncryptNonSytemDrives() {
		param (
			[string]$networkKeyBackupFolder
		)
		# Other drives encryption
		$listVolume = Get-volume | Where-Object { $_.DriveType -eq "Fixed" -and $_.DriveLetter -ne $systemDriveLetter }
		Foreach ($volume in $listVolume) {
			If (-not ($volume.DriveLetter)) { continue }

			$letter = $volume.DriveLetter
			$letterColon = $letter + ":"
			#if (Test-Path $letter){
			$cryptDrive = Read-Host -Prompt "The $letter drive is not removable and hosts a file system. Do you want to enable encryption on this drive? [Y/n]"
			If ($cryptDrive -eq "n") { continue }

			# Test if partition is already encrypted (like for C:)
			If ((Get-BitLockerVolume $letter).ProtectionStatus -eq "on") {
				Write-Host "Bitlocker on drive $letter is already ON!"
				continue
			}

			Write-Host "Bitlocker activation on drive $letter is going to start"

			Enable-BitLocker -MountPoint $letter -RecoveryPasswordProtector -UsedSpaceOnly -EncryptionMethod "XtsAes256" 3> $null
			Resume-BitLocker -MountPoint $letter
			Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 1 -Message "SWMB: Bitlocker enable drive $letter"

			Write-Host "Copy drive $letter key"
			$backupFile = $systemDrive + "\" + $Env:ComputerName + "-bitlockerRecoveryKey-" + $dateNow + "-" + $letter + ".txt"
			Write-Host $backupFile
			(Get-BitLockerVolume -MountPoint $letterColon).KeyProtector > $backupFile

			icacls.exe $backupFile /Reset
			icacls.exe $backupFile /Grant:r "$((Get-Acl -Path $backupFile).Owner):(R)"
			icacls.exe $backupFile /InheritanceLevel:r
			Write-Host "Bitlocker activation on drive $letter ended with success"

			# copy key if $networkKeyBackup
			If (-not ([string]::IsNullOrEmpty($networkKeyBackupFolder))) {
				Try {
					Copy-Item $backupFile -Destination $networkKeyBackupFolder -ErrorAction Continue
				}
				Catch {
					$message = "Error backuping $backupFile on network folder $networkKeyBackupFolder"
					Write-Host $message
					Write-EventLog -LogName Application -Source "SWMB" -EntryType Warning -EventID 4 -Message $message
				}
			}

			# AutoUnlock
			If ((Get-BitLockerVolume $Env:SystemDrive).ProtectionStatus -eq "on") {
				Enable-BitLockerAutoUnlock -MountPoint $letter
			}
			Else {
				$trigger = New-ScheduledTaskTrigger -AtStartup
				$user    = "NT AUTHORITY\SYSTEM"
				$key_obj = (Get-BitLockerVolume -MountPoint $letter).KeyProtector | Where-Object {$_.KeyProtectorType -eq 'RecoveryPassword'} | Select-Object -Property RecoveryPassword
				$key     = $key_obj.RecoveryPassword
				$task    = 'swmb-bitlocker-' + $letter + '-' + (Get-Random -Minimum 1000 -Maximum 9999)
				$action  = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command &{Unlock-BitLocker -MountPoint $letter -RecoveryPassword $key ; Enable-BitLockerAutoUnlock -MountPoint $letter ; Write-EventLog -LogName Application -Source 'SWMB' -EntryType Information -EventID 5 -Message 'SWMB: Bitlocker finish ScheduledTask $task' ; Unregister-ScheduledTask $task -confirm:`$false}"
				Register-ScheduledTask -Force -TaskName $task -Trigger $trigger -User $user -Action $action -RunLevel Highest
				Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 4 -Message "SWMB: Bitlocker add ScheduledTask $task"
				#$cmd     = "&{Unlock-BitLocker -MountPoint $letter -RecoveryPassword $key ; Enable-BitLockerAutoUnlock -MountPoint $letter}"
				#Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "Enable-BitLockerAutoUnlock-$letter" -Value "powershell.exe -noexit -command '$cmd'"
			}
		}
	}

	Function _EnforceCryptGPO() {
		# All registry keys :
		# https://getadmx.com/HKLM/Software/Policies/Microsoft/FVE
		If (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE")) {
			New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\" -Name "FVE"
		}

		# 256 bits# XTS-AES 256-bit
		# https://admx.help/?Category=MDOP&Policy=Microsoft.Policies.BitLockerManagement::BLEncryptionMethodWithXts_Name

		# Encryption method for operating system drives
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "EncryptionMethodWithXtsOs" -Value 7
		# Encryption method for fixed data drives
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "EncryptionMethodWithXtsFdv" -Value 7
		# Encryption method for removable data drives
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "EncryptionMethodWithXtsRdv" -Value 7

		# Additional authentication at startup
		# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.VolumeEncryption::ConfigureAdvancedStartup_Name
		# If you enable this policy setting, users can configure advanced startup options in the BitLocker setup wizard.
		# If you disable or do not configure this policy setting, users can configure only basic options on computers with a TPM.
		# Active this GPO
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseAdvancedStartup" -Value 1
		# Don't allow bitlocker without TPM
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "EnableBDEWithNoTPM" -Value 0
		# Dont allow =>0, allow =>2, require=>1
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPM" -Value 2
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMPIN" -Value 2
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMKey" -Value 2
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMKeyPIN" -Value 2
		# Disable PIN change by a standard user
		# https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.VolumeEncryption::DisallowStandardUsersCanChangePIN_Name
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "DisallowStandardUserPINReset" -Value 1

		# Allowed recovery method
		# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.VolumeEncryption::OSRecoveryUsage_Name
		# Active this GPO
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSRecovery" -Value 1
		# Allow data recovery agent
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSManageDRA" -Value 1
		# Allow 48-digit recovery password
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSRecoveryPassword" -Value 2
		# Allow 256-bit recovery key
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSRecoveryKey" -Value 2
		# Omit recovery options from the BitLocker setup wizard
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSHideRecoveryPage" -Value 0
		# Don't Save BitLocker recovery information to AD DS for operating system drives
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSActiveDirectoryBackup" -Value 0
		# Store recovery passwords and key packages
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSActiveDirectoryInfoToStore" -Value 1
		# Do not enable BitLocker until recovery information is stored to AD DS for operating system drives
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSRequireActiveDirectoryBackup" -Value 0

		# Update GPO
		gpupdate
	}

	# Begin main program
	$dateNow           = (Get-Date).ToString("yyyyMMddhhmm")
	$systemDrive       = $Env:SystemDrive
	$systemDriveLetter = $systemDrive.Substring(0, 1)

	If (!(Get-Eventlog -LogName Application -Source "SWMB")){
		New-EventLog -LogName Application -Source "SWMB"
	}

	If (!(Confirm-SecureBootUEFI)) {
		Write-Error "SecureBoot is OFF!"
		return
	}
	If (!(Get-Tpm).TpmReady) {
		Write-Host "Get-TPM informations"
		Get-Tpm
		Write-Error "TPM not ready!"
		return
	}

	# BEGIN GPO
	_EnforceCryptGPO

	$networkBackup = _NetworkKeyBackup -wantToSave $false

	$sytemDriveStatus = (Get-BitLockerVolume $systemDrive).VolumeStatus

	If ($sytemDriveStatus -eq "DecryptionInProgress") {
		Write-Error "Bitlocker decryption on $systemDrive is in progress!"
		return
	}

	Write-Host "Bitlocker Volume Status encryption on $systemDrive is $sytemDriveStatus"

	If (((Get-BitLockerVolume $Env:SystemDrive).ProtectionStatus -eq "On") -or ($sytemDriveStatus -eq "EncryptionInProgress")) {
		Write-Host "Bitlocker on system drive is already on (or in progress)"
		_EncryptNonSytemDrives -networkKeyBackupFolder $networkBackup
	}
	Else {
		_EncryptSytemDrive -networkKeyBackupFolder $networkBackup
		_EncryptNonSytemDrives -networkKeyBackupFolder $networkBackup

		$reboot = Read-Host -Prompt "The computer must be restarted to finish the system disk encryption. Reboot now? [Y/n]"
		If ($reboot -ne "n") {
			Restart-Computer -Force
		}
	}
}

# Disable
Function DisableBitlocker {
	$listVolume = Get-volume | Where-Object { $_.DriveType -eq "Fixed" }
	Foreach ($volume in $listVolume) {
		If (-not ($volume.DriveLetter)) { continue }
		$letter = $volume.DriveLetter
		Disable-BitLocker $letter
	}
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
