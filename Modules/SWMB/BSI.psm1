################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2021, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb
# Authors:
#  2021 - Sébastien Morin (CNRS / DCM)
#  2021 - Olivier de Marchi (Grenoble INP / LEGI)
#  2021 - David Gras (CNRS / DR11)
#  2021 - Clément Deiber (CNRS / DR11)
#  2021 - Gabriel Moreau (CNRS / LEGI)
################################################################

#Write-host @"
#
#TEST DES CLES DE REGISTRE DE LA BSI ALLEMANDE ET PROPOSITION DE CORRECTION SI INACTIVES
#
#Pour pouvoir exécuter le script téléchargé et non signé, faire ceci avant de le lancer :
#dir -Path C:\SWMB\resinfo-swmb-master -Recurse | Unblock-File
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

#"@ -ForegroundColor Green

################################################################

### Les Connected User Experiences et Telemetry sont ils activés ? (oui si 2, non si 4)

# Disable
Function DisableConnectedUserExperiencesAndTelemetry {
	Write-Output "Désactivation des Connected User Experiences et de la Télémétrie..."
	If (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack")) {
		New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack" -Name "Start" -Type DWord -Value 4
}

# Enable
Function EnableConnectedUserExperiencesAndTelemetry {
	Write-Output "Activation des Connected User Experiences et de la Télémétrie..."
	If (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack")) {
		New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack" -Name "Start" -Type DWord -Value 2
}

# View
Function ViewNoConnectedUserExperiencesAndTelemetry {
	Write-Output 'Connected User Experiences and Telemetry (2 activated, 4 no)'
	Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack" -Name "Start"
}

################################################################

# La session "Autologger-DiagTrack-Listener" doit être désactivée en mettant sa clé de registre à zéro
# Par défaut cette clé ne semble pas exister, on l'efface donc en fonction Disable, comme avant

# Disable
Function DisableAutologgerDiagTrack {
	Write-Output "Désactivation du Autologger-DiagTrack-Listener..."
	Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" -Force | Out-Null
}

# Enable
Function EnableAutologgerDiagTrack {
	Write-Output "Activation du Autologger-DiagTrack-Listener..."
	If (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener")) {
		New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" -Name "Start" -Type DWord -Value 2
}

# View
Function ViewEnableAutologgerDiagTrack {
	Write-Output 'Autologger-DiagTrack-Listener (0 no or not exist, 2 activated)'
	Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" -Name "Start"
}

################################################################

# Désactivation des anciennes versions de PowerShell (2.0) qui ne proposent pas les fonctionnalités de sécurité avancées

# Disable
Function DisablePowershell2 {
	Write-Output "Désactivation des anciennes versions de Powershell(2)..."
	Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root
}

# Enable
Function EnablePowershell2 {
	Write-Output "Activation des anciennes versions de Powershell(2)..."
	Enable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root
}

################################################################

# Désactivation de l'utilisation de PowerShell à distance
#PAS ENCORE FAIT

# Disable
Function DisableRemotePowershell {
	Write-Output "Désactivation de l'utilisation de PowerShell à distance"
	Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root
}

# Enable
Function EnableRemotePowershell {
	Write-Output "Activation de l'utilisation de PowerShell à distance"
	Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *

