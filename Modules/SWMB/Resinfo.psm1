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
Function TweakDisableOverrideReportingMAPS { # RESINFO
	Write-Output "Disabling override for reporting to Microsoft MAPS..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "LocalSettingOverrideSpynetReporting" -Type DWord -Value 0
}

# Enable
Function TweakEnableOverrideReportingMAPS { # RESINFO
	Write-Output "Enabling override for reporting to Microsoft MAPS..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "LocalSettingOverrideSpynetReporting" -Type DWord -Value 1 -ErrorAction SilentlyContinue
}

################################################################

# ANSSI Annexe A3
# https://getadmx.com/?Category=Windows10_Telemetry&Policy=Microsoft.Policies.Win10Privacy::DontReportInfection

Function TweakDisableMRTReportInfectionInformation { # RESINFO
	Write-Output "Disable Malicious Software Reporting tool diagnostic data..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontReportInfectionInformation" -Type DWord -Value 1
}

# Enable
Function TweakEnableMRTReportInfectionInformation { # RESINFO
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
Function TweakDisablePrivacyExperience { # RESINFO
	Write-Output "Disabling privacy experience from launching during user logon for new and upgraded users..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" -Name "DisablePrivacyExperience" -Type DWord -Value 1
}

# Enable
Function TweakEnablePrivacyExperience { # RESINFO
	Write-Output "Enabling privacy experience from launching during user logon for new and upgraded users..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE" -Name "DisablePrivacyExperience" -Type DWord -Value 0 -ErrorAction SilentlyContinue
}

################################################################

### Enregistreur d'actions utilisateur
# https://support.microsoft.com/en-us/help/22878/windows-10-record-steps
# Disable
Function TweakDisableStepsRecorder { # RESINFO
	Write-Output "Disabling Windows steps recorder..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "DisableUAR" -Type DWord -Value 1
}

# Enable
Function TweakEnableStepsRecorder { # RESINFO
	Write-Output "Enable Windows steps recorder..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "DisableUAR" -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Système / Gestion de la communication Internet / Paramètres de communication Internet
# ANSSI Annexe C1
# https://gpsearch.azurewebsites.net/#4723
# Disable
Function TweakDisableDidYouKnow { # RESINFO
	Write-Output "Turn off Help and Support Center Did you know? content..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc" -Name "Headlines" -Type DWord -Value 1
}

# Enable
Function TweakEnableDidYouKnow { # RESINFO
	Write-Output "Turn on Help and Support Center Did you know? content..."
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc" -Name "Headlines" -Type DWord -Value 0 -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Système / Gestion de la communication Internet / Paramètres de communication Internet
# ANSSI Annexe C1
# https://gpsearch.azurewebsites.net/#4754
# Disable
Function TweakDisableHandwritingDataSharing { # RESINFO
	Write-Output "Turn off handwriting personalization data sharing..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\TabletPC")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\TabletPC" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\TabletPC" -Name "PreventHandwritingDataSharing" -Type DWord -Value 1
}

# Enable
Function TweakEnableHandwritingDataSharing { # RESINFO
	Write-Output "Turn on handwriting personalization data sharing..."
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\TabletPC" -Name "PreventHandwritingDataSharing" -Type DWord -Value 0 -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Système / Gestion de la communication Internet / Paramètres de communication Internet
# ANSSI Annexe C1
# https://gpsearch.azurewebsites.net/#4743
# Disable
Function TweakDisableHandwritingRecognitionErrorReporting { # RESINFO
	Write-Output "Turn off handwriting recognition error reporting..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports\")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports\" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports\" -Name "PreventHandwritingErrorReports" -Type DWord -Value 1
}

# Enable
Function TweakEnableHandwritingRecognitionErrorReporting { # RESINFO
	Write-Output "Turn on handwriting recognition error reporting..."
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports\" -Name "PreventHandwritingErrorReports" -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Système / Gestion de la communication Internet / Paramètres de communication Internet
# ANSSI Annexe C1
# https://gpsearch.azurewebsites.net/#4727
# Disable
Function TweakDisableWindowsErrorReporting { # RESINFO
	Write-Output "Turn off Windows error reporting..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports\" -Name "DoReport" -Type DWord -Value 0
}

# Enable
Function TweakEnableWindowsErrorReporting { # RESINFO
	Write-Output "Turn on Windows error reporting..."
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting" -Name "DoReport" -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Composants Windows / Rapport d'erreurs Windows / Envoyer automatiquement des images mémoires pour les rapports
# key AutoApproveOSDumps
# https://getadmx.com/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsErrorReporting::WerAutoApproveOSDumps_2
# GPO Desactivé par défaut
# Disable
Function TweakDisableOsGeneratedReport { # RESINFO
	Write-Output "Turn off OS-generated error reports"
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Name "AutoApproveOSDumps" -Type DWord -Value 0
}

# Enable
Function TweakEnableOsGeneratedReport { # RESINFO
	Write-Output "Turn on OS-generated error reports"
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Name "AutoApproveOSDumps" -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Composants Windows / Rapport d'erreurs Windows / Ne pas envoyer des données complémentaires
# key DontSendAdditionalData
# https://getadmx.com/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsErrorReporting::WerNoSecondLevelData_2
# GPO activé par défaut
# Disable
Function TweakDisableSendAdditionalData { # RESINFO
	Write-Output "Disable Error reporting Send Additional Data"
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Name "DontSendAdditionalData" -Type DWord -Value 1
}

# Enable
Function TweakEnableSendAdditionalData { # RESINFO
	Write-Output "Enable Error reporting Send Additional Data"
	Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting" -Name "DontSendAdditionalData" -ErrorAction SilentlyContinue
}

################################################################

# Configuration ordinateur / Modèles d'administration / Panneau de Configuration / Options Regionales et Linguistiques / Personnalisation de l'écriture manuscrite / Désactiver l’apprentissage automatique / Activé
# https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.Globalization::ImplicitDataCollectionOff_2
# Disable
Function TweakDisableAutomaticLearning { # RESINFO
	Write-Output "Turn off automatic learning..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\InputPersonalization")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\InputPersonalization" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
}

# Enable
Function TweakEnableAutomaticLearning { # RESINFO
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
Function TweakDisablePrivateStoreOnly { # RESINFO
	Write-Output "Disable PrivateStoreOnly..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "RequirePrivateStoreOnly" -Type DWord -Value 0
}

# Enable
Function TweakEnablePrivateStoreOnly { # RESINFO
	Write-Output "Enable PrivateStoreOnly..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "RequirePrivateStoreOnly" -Type DWord -Value 1
}

################################################################

### Déactiver le Windows Store
# https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsStore::RemoveWindowsStore_2
# Configuration ordinateur / Modèles d'administration / Composants Windows / WindowsStore / Desactiver l'application / active
# Disable
Function TweakDisableWindowsStore { # RESINFO
	Write-Output "Disable Windows Store..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "RemoveWindowsStore" -Type DWord -Value 1
}

# Enable
Function TweakEnableWindowsStore { # RESINFO
	Write-Output "Enable Windows Store..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "RemoveWindowsStore" -Type DWord -Value 0
}

################################################################

# Configuration ordinateur / Modèles d'administration / Composants Windows / WindowsStore / Désactiver toutes les applications du Windows Store / activé
# https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsStore::DisableStoreApps&Language=fr-fr
# Disable
Function TweakDisableStoreApps { # RESINFO
	Write-Output "Disable StoreApps..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "DisableStoreApps" -Type DWord -Value 1
}

# Enable
Function TweakEnableStoreApps { # RESINFO
	Write-Output "Enable StoreApps..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\WindowsStore")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsStore" -Name "DisableStoreApps" -Type DWord -Value 0
}

################################################################

Function TweakDisableAppsAccessAccount { # RESINFO
	Write-Output "Windows apps are not allowed to access account information..."
	If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy")) {
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo" -Type DWord -Value 2 -Force | Out-Null
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo_ForceDenyTheseApps" -Type MultiString -value $null -Force | Out-Null
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo_UserInControlOfTheseApps" -Type MultiString -value $null -Force | Out-Null
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo_ForceAllowTheseApps" -Type MultiString -value $null -Force | Out-Null
}

Function TweakEnableAppsAccessAccount { # RESINFO
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
Function TweakDisableMicrosoftAccount { # RESINFO
	Write-Output "Block Microsoft Account..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoConnectedUser" -Type DWord -Value 3
}

# Enable
Function TweakEnableMicrosoftAccount { # RESINFO
	Write-Output "Enable Microsoft Account..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoConnectedUser" -Type DWord -Value 0
}

################################################################

# Windows Hello Authentification
# https://answers.microsoft.com/en-us/windows/forum/windows_10-hello/how-to-disable-windows-hello/05ab5492-19c7-4d44-b762-d93b44a9cf65
# https://www.minitool.com/news/disable-windows-hello.html
# Computer Configuration -> Administrative Templates -> System -> Logon : Turn on PIN sign-in and select Disabled.
# Disable
Function TweakDisableWindowsHello { # RESINFO
	Write-Output "Block Windows Hello Authentification..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions" -Name "value" -Type DWord -Value 0
}

# Enable
Function TweakEnableWindowsHello { # RESINFO
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
Function TweakDisableCortanaAboveLock { # RESINFO
	Write-Output "Disable Cortana AboveLock..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortanaAboveLock" -Type DWord -Value 0
}

# Enable
Function TweakEnableCortanaAboveLock { # RESINFO
	Write-Output "Enable Cortana AboveLock..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortanaAboveLock" -Type DWord -Value 1
}

################################################################

# Configuration ordinateur / Modèles d'administration / Composants Windows / Rechercher / Autoriser l'indexation des fichiers chiffrés / desactivé
# https://getadmx.com/?Category=Windows_10_2016&Policy=FullArmor.Policies.3B9EA2B5_A1D1_4CD5_9EDE_75B22990BC21::AllowIndexingEncryptedStoresOrItems
# ANSSI Annexe B1
Function TweakDisableIndexingEncryptedStores { # RESINFO
	Write-Output "Disable IndexingEncryptedStores..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowIndexingEncryptedStoresOrItems" -Type DWord -Value 0
}

# Enable
Function TweakEnableIndexingEncryptedStores { # RESINFO
	Write-Output "Allow IndexingEncryptedStores..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowIndexingEncryptedStoresOrItems" -Type DWord -Value 1
}

################################################################

# Configuration ordinateur / Modèles d'administration / Composants Windows / Rechercher / Définir quelles informations sont partagées dans search / activé type => informations anonymes
# https://getadmx.com/?Category=Windows_10_2016&Policy=FullArmor.Policies.3B9EA2B5_A1D1_4CD5_9EDE_75B22990BC21::SearchPrivacy
# ANSSI Annexe B1
Function TweakDisableSharedInformationSearch { # RESINFO
	Write-Output "Anonymous information is shared in Search..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "ConnectedSearchPrivacy" -Type DWord -Value 3
}

# Enable
Function TweakEnableSharedInformationSearch { # RESINFO
	Write-Output "User info and location is shared in Search..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "ConnectedSearchPrivacy" -Type DWord -Value 1
}

################################################################

# Configuration ordinateur / Modèles d'administration / Composants Windows / Rechercher / Ne pas effectuer des rechechers sur le web ou afficher dse résultats Web dans search / activé
# https://getadmx.com/?Category=Windows_10_2016&Policy=FullArmor.Policies.3B9EA2B5_A1D1_4CD5_9EDE_75B22990BC21::DoNotUseWebResults
# ANSSI Annexe B1
Function TweakDisableDisplayWebResults { # RESINFO
	Write-Output "Don't search the web or display web results in Search..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "ConnectedSearchUseWeb" -Type DWord -Value 0
}

# Enable
Function TweakEnableDisplayWebResults { # RESINFO
	Write-Output "Web results will be displayed ..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "ConnectedSearchUseWeb" -Type DWord -Value 1
}

################################################################

# Windows_FW_Rules_DR11
# GPO Configuration Ordinateur / Paramètres Windows / Paramètres de sécurité / Pare-feu Windows avec sécurité avancée
# Paramètres du profil de domaine | Paramètres du profil privé | Paramètres du profil public

# Disable Firewall
Function TweakDisableDomainProfile { # RESINFO
	Write-Output "Disabling Domain Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Name "EnableFirewall" -Type DWord -Value 0
}

Function TweakDisablePrivateProfile { # RESINFO
	Write-Output "Disabling Private Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "EnableFirewall" -Type DWord -Value 0
}

################################################################

Function TweakDisablePublicProfile { # RESINFO
	Write-Output "Disabling Public Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -Name "EnableFirewall" -Type DWord -Value 0
}

# Enable Firewall
Function TweakEnableDomainProfile { # RESINFO
	Write-Output "Enabling Domain Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Name "EnableFirewall" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Name "DefaultInboundAction" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -Name "DefaultOutboundAction" -Type DWord -Value 0
}

################################################################

Function TweakEnablePrivateProfile { # RESINFO
	Write-Output "Enabling Private Profile..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "EnableFirewall" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "DefaultInboundAction" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "DefaultOutboundAction" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -Name "DoNotAllowExceptions" -Type DWord -Value 1
}

################################################################

Function TweakEnablePublicProfile { # RESINFO
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

################################################################

# Turn off hybrid sleep
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.PowerManagement::DCStandbyWithHiberfileEnable_2
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.PowerManagement::ACStandbyWithHiberfileEnable_2
# Disable
Function TweakDisableHybridSleep { # RESINFO
	Write-Output "Turn off hybrid sleep (plugged in and battery)..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e" -Name "ACSettingIndex" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\94ac6d29-73ce-41a6-809f-6363ba21b47e" -Name "DCSettingIndex" -Type DWord -Value 0
}

# Enable
Function TweakEnableHybridSleep { # RESINFO
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
Function TweakEnableBitlocker { # RESINFO
	## PowerShell bitlocker commands
	# https://docs.microsoft.com/en-us/powershell/module/bitlocker/?view=win10-ps

	Function _NetworkKeyBackup() {
		Param (
			[Parameter(Mandatory = $true)] [string]$WantToSave
		)

		If ($WantToSave -eq $false) {
			$IsNetWorkBackup = Read-Host -Prompt "Do you want to save recovery keys on a network drive? [y/N]"
			If ($IsNetWorkBackup.ToLower() -ne "y") {
				Return $null
			}
		}

		Do {
			$NetworkKeyBackup = Read-Host -Prompt "Provide a CIFS/SMB writable network path with UNC syntax \\serverName\SharedFolder"
		} until (($NetworkKeyBackup.Length -gt 2) -and ("\\" -ccontains $NetworkKeyBackup.Substring(0, 2)))

		If ($NetworkKeyBackup.Substring($NetworkKeyBackup.Length - 1) -ne "\") {
			$NetworkKeyBackup += "\"
		}

		Try {
			New-Item -Name isWriteAllowed.txt -ItemType File -Path $NetworkKeyBackup -Force -ErrorAction stop | Out-Null
			Return $NetworkKeyBackup
			# Todo question : do I delete the file afterwards?
		} Catch {
			Write-Output ("$NetworkKeyBackup is not writable! Choose another location!") -ForegroundColor Red
			_NetworkKeyBackup -wantToSave $true
		}
	}

	Function _DecryptAndWait () {
		Param (
			[string]$Letter
		)

		Disable-BitLocker -MountPoint $Letter
		Write-Output "decryption in progress for $Letter"
		While ((Get-BitLockerVolume -MountPoint $Letter).EncryptionPercentage -gt 0 ) {
			Start-Sleep -Seconds 20
		}
		Write-Output "$Letter is fully decrypted"
	}

	Function _EncryptSytemDrive() {
		Param (
			[string]$NetworkKeyBackupFolder
		)

		#$title = 'Activation bitlocker'
		#$query = 'Do you want to use PIN?'
		#$choices = '&Yes', '&No'
		#$decision = $Host.UI.PromptForChoice($title, $query, $choices, 1)
		$UseCodePin = Read-Host -Prompt "Activation bitlocker - Do you want to use PIN code? [Y/n]"
		If ($UseCodePin.ToLower() -ne "n") {
			$Secure = Read-Host -AsSecureString -Prompt "Code PIN (6 digits)"
			Write-Output "Enable bitlocker on system drive $SystemDrive with PIN code"
			Enable-BitLocker -MountPoint "$SystemDrive" -TpmAndPinProtector -Pin $Secure -EncryptionMethod "XtsAes256" 3> $null
			Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 2 `
				-Message "SWMB: Enable bitlocker on system drive $SystemDrive with PIN code"
		} Else {
			Write-Output "Enable bitlocker on system drive $SystemDrive without PIN code"
			Enable-BitLocker -MountPoint "$SystemDrive" -TpmProtector -EncryptionMethod "XtsAes256"
			Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 3 `
				-Message "SWMB: Enable bitlocker on system drive $SystemDrive without PIN code"
		}

		Write-Output "Add system drive key"
		Add-BitLockerKeyProtector -MountPoint "$SystemDrive" -RecoveryPasswordProtector
		Write-Output "Copy system drive key on $SystemDrive"
		$PathKey = $SystemDrive + "\" + $Env:ComputerName + "-bitlockerRecoveryKey-" + $DateNow + "-" + $SystemDriveLetter + ".txt"
		If (Test-Path -Path $PathKey -PathType leaf) {
			$oldKey = $SystemDrive + "\" + $Env:ComputerName + "-bitlockerRecoveryKey-" + $DateNow + "-" + $SystemDriveLetter + ".txt.old"
			Write-Output "Warning: $PathKey already exist => rename with .old extension"
			If (Test-Path -Path $oldKey -PathType leaf) {
				Write-Output "Warning: delete before old key $oldKey"
				Remove-Item -Path $oldKey -Force
			}
			Rename-Item -Path $PathKey -NewName $oldKey
		}
		(Get-BitLockerVolume -MountPoint $SystemDriveLetter).KeyProtector > $PathKey
		# acl on key see https://stackoverflow.com/a/43317244
		icacls.exe $PathKey /Reset
		icacls.exe $PathKey /Grant:r "$((Get-Acl -Path $PathKey).Owner):(R)"
		icacls.exe $PathKey /InheritanceLevel:r

		# copy key if $NetworkKeyBackup
		If (-not ([string]::IsNullOrEmpty($NetworkKeyBackupFolder))) {
			Try {
				Copy-Item $PathKey -Destination $NetworkKeyBackupFolder -ErrorAction Continue
			} Catch {
				$Message = "Error backuping $PathKey on network folder $NetworkKeyBackupFolder"
				Write-Output $Message
				Write-EventLog -LogName Application -Source "SWMB" -EntryType Warning -EventID 4 -Message $Message
			}
		}
	}

	# We treat all partitions that have an associated letter and that are of type fixed
	# ie we don't take into account the usb keys
	Function _EncryptNonSytemDrives() {
		Param (
			[string]$NetworkKeyBackupFolder
		)

		# Other drives encryption
		$ListVolume = Get-volume | Where-Object { $_.DriveType -eq "Fixed" -and $_.DriveLetter -ne $SystemDriveLetter }
		Foreach ($Volume in $ListVolume) {
			If (-not ($Volume.DriveLetter)) { continue }

			$Letter = $Volume.DriveLetter
			$LetterColon = $Letter + ":"
			#if (Test-Path $Letter){
			$cryptDrive = Read-Host -Prompt "The $Letter drive is not removable and hosts a file system. Do you want to enable encryption on this drive? [Y/n]"
			If ($cryptDrive.ToLower() -eq "n") { continue }

			# Test if partition is already encrypted (like for C:)
			If ((Get-BitLockerVolume $Letter).ProtectionStatus -eq "On") {
				Write-Output "Bitlocker on drive $Letter is already ON!"
				continue
			}

			Write-Output "Bitlocker activation on drive $Letter is going to start"

			Enable-BitLocker -MountPoint $Letter -RecoveryPasswordProtector -UsedSpaceOnly -EncryptionMethod "XtsAes256" 3> $null
			Resume-BitLocker -MountPoint $Letter
			Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 1 -Message "SWMB: Bitlocker enable drive $Letter"

			Write-Output "Copy drive $Letter key"
			$BackupFile = $SystemDrive + "\" + $Env:ComputerName + "-bitlockerRecoveryKey-" + $DateNow + "-" + $Letter + ".txt"
			Write-Output $BackupFile
			(Get-BitLockerVolume -MountPoint $LetterColon).KeyProtector > $BackupFile

			icacls.exe $BackupFile /Reset
			icacls.exe $BackupFile /Grant:r "$((Get-Acl -Path $BackupFile).Owner):(R)"
			icacls.exe $BackupFile /InheritanceLevel:r
			Write-Output "Bitlocker activation on drive $Letter ended with success"

			# copy key if $NetworkKeyBackup
			If (-not ([string]::IsNullOrEmpty($NetworkKeyBackupFolder))) {
				Try {
					Copy-Item $BackupFile -Destination $NetworkKeyBackupFolder -ErrorAction Continue
				} Catch {
					$Message = "Error backuping $BackupFile on network folder $NetworkKeyBackupFolder"
					Write-Output $Message
					Write-EventLog -LogName Application -Source "SWMB" -EntryType Warning -EventID 4 -Message $Message
				}
			}

			# AutoUnlock
			If ((Get-BitLockerVolume $Env:SystemDrive).ProtectionStatus -eq "On") {
				Enable-BitLockerAutoUnlock -MountPoint $Letter
			} Else {
				$TaskTrigger  = New-ScheduledTaskTrigger -AtStartup
				$TaskUser     = "NT AUTHORITY\SYSTEM"
				$KeyProtector = (Get-BitLockerVolume -MountPoint $Letter).KeyProtector | Where-Object {$_.KeyProtectorType -eq 'RecoveryPassword'} | Select-Object -Property RecoveryPassword
				$Password     = $KeyProtector.RecoveryPassword
				$TaskName     = 'swmb-bitlocker-' + $Letter + '-' + (Get-Random -Minimum 1000 -Maximum 9999)
				$TaskAction   = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command &{Unlock-BitLocker -MountPoint $Letter -RecoveryPassword $Password ; Enable-BitLockerAutoUnlock -MountPoint $Letter ; Write-EventLog -LogName Application -Source 'SWMB' -EntryType Information -EventID 5 -Message 'SWMB: Bitlocker finish ScheduledTask $TaskName' ; Unregister-ScheduledTask $TaskName -confirm:`$false}"
				Register-ScheduledTask -Force -TaskName $TaskName -Trigger $TaskTrigger -User $TaskUser -Action $TaskAction -RunLevel Highest
				Write-EventLog -LogName Application -Source "SWMB" -EntryType Information -EventID 4 -Message "SWMB: Bitlocker add ScheduledTask $TaskName"
				#$cmd     = "&{Unlock-BitLocker -MountPoint $Letter -RecoveryPassword $Password ; Enable-BitLockerAutoUnlock -MountPoint $Letter}"
				#Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "Enable-BitLockerAutoUnlock-$Letter" -Value "powershell.exe -noexit -command '$cmd'"
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
	$DateNow           = (Get-Date).ToString("yyyyMMddhhmm")
	$SystemDrive       = $Env:SystemDrive
	$SystemDriveLetter = $SystemDrive.Substring(0, 1)

	$DrivePStatus = (Get-BitLockerVolume $SystemDrive).ProtectionStatus
	$DriveVStatus = (Get-BitLockerVolume $SystemDrive).VolumeStatus
	$DriveEMethod = (Get-BitLockerVolume $SystemDrive).EncryptionMethod

	If (!(Get-Eventlog -LogName Application -Source "SWMB")){
		New-EventLog -LogName Application -Source "SWMB"
	}

	If (!(Confirm-SecureBootUEFI)) {
		Write-Error "SecureBoot is OFF!"
		Return
	}
	If (!(Get-Tpm).TpmReady) {
		Write-Output "Get-TPM informations"
		Get-Tpm
		Write-Error "TPM not ready!"
		Return
	}

	If (($DriveVStatus -eq "FullyDecrypted") -and ((Get-BitLockerVolume $SystemDrive).KeyProtector)) {
		Write-Warning "Your are FullyDecrypted with a Key protector. Your computer need reboot"
		return
	}

	If ($DriveEMethod -eq "None") {
		# use network to save key ?
		$NetworkBackup = _NetworkKeyBackup -wantToSave $false

		# Disk ready for encryption
		_EnforceCryptGPO
		_EncryptSytemDrive -networkKeyBackupFolder $NetworkBackup
		_EncryptNonSytemDrives -networkKeyBackupFolder $NetworkBackup

		$reboot = Read-Host -Prompt "The computer must be restarted to finish the system disk encryption. Reboot now? [Y/n]"
		If ($reboot.ToLower() -ne "n") {
			Restart-Computer -Force
		}
	} ElseIf ($DriveEMethod -eq "XtsAes256") {
		# Disk crypt but...
		If (($DriveVStatus -eq "DecryptionInProgress") -or ($DriveVStatus -eq "EncryptionInProgress")) {
			Write-Warning "Operation in progress on your $Env:SystemDrive => $DriveVStatus"
			Write-Output ("Stop and try later - Encryption percentage = " + (Get-BitLockerVolume $SystemDrive).EncryptionPercentage)
			Return
		} Else {
			If ($DrivePStatus -eq "On") {
				Write-Warning "Your $Env:SystemDrive is already encrypt (XtsAes256) and activated"
				Write-Output "Nothing to do on System drive !"

				# use network to save key ?
				$NetworkBackup = _NetworkKeyBackup -wantToSave $false
				_EncryptNonSytemDrives -networkKeyBackupFolder $NetworkBackup
				Return
			} Else {
				Write-Output "Bitlocker is suspend, resume with :"
				Write-Output "Resume-BitLocker $SystemDrive ... and save your key"
			}
		}
	} ElseIf ($DriveEMethod -ne "XtsAes256") {
		# Disk crypt but not with XtsAes256
		Write-Warning "Your $Env:SystemDrive is not encrypt in XtsAes256, the encryption is $DriveEMethod"
		Write-Output "Decrypt with command : .\swmb.ps1 DisableBitlocker"
		Return
	}
}

# Disable
Function TweakDisableBitlocker { # RESINFO
	$ListVolume = Get-volume | Where-Object { $_.DriveType -eq "Fixed" }
	Foreach ($Volume in $ListVolume) {
		If (-not ($Volume.DriveLetter)) { continue }
		$Letter = $Volume.DriveLetter
		Disable-BitLocker $Letter
	}
}

################################################################

# Suspend or Resume Bitlocker
# Set
Function TweakSetBitlockerActive { # RESINFO
	Write-Output "Set bitlocker on all crypt drive (resume)..."
	Get-BitLockerVolume | Resume-BitLocker
}

# Unset
Function TweakUnsetBitlockerActive { # RESINFO
	Write-Output "Unset bitlocker on all crypt drive (suspend)..."
	Get-BitLockerVolume | Suspend-BitLocker -RebootCount 0
}

################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
