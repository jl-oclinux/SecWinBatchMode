#Requires -Version 4.0
#Requires -RunAsAdministrator



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

# Enable
Function EnableNoConnectedUserExperiencesAndNoTelemetry {
	Write-Output "Désactivation des Connected User Experiences et de la Télémétrie"
	If (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack")) {
		New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack" -Name "Start" -Type DWord -Value 4 -ErrorAction SilentlyContinue
    Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack -Name Start | Outfile Z:test.txt

}

# Disable
Function DisableNoConnectedUserExperiencesAndNoTelemetry {
	Write-Output "Activation des Connected User Experiences et de la Télémétrie"
	If (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack")) {
		New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack" -Name "Start" -Type DWord -Value 2 -ErrorAction SilentlyContinue
}



################################################################

### La session "Autologger-DiagTrack-Listener" doit être désactivée en mettant sa clé de registre à zéro
# Par défaut cette clé ne semble pas exister, on l'efface donc en fonction Disable, comme avant

# Enable
Function EnableNoEnableNoAutologgerDiagTrackListener {
	Write-Output "Désactivation du Autologger-DiagTrack-Listener"
	If (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener")) {
		New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" -Name "Start" -Type DWord -Value 0 -ErrorAction SilentlyContinue

}

# Disable
Function DisableNoEnableNoAutologgerDiagTrackListener {
	Write-Output "Activation du Autologger-DiagTrack-Listener"
    Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" -Force | Out-Null
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" -Name "Start" -Type DWord -Value 2 -ErrorAction SilentlyContinue
}




################################################################

### Désactivation des anciennes versions de PowerShell (2.0) qui ne proposent pas les fonctionnalités de sécurité avancées

# Enable
Function EnableDeactivationOlderPowershell2 {
	Write-Output "Désactivation des anciennes versions de Powershell(2)"
	Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root
}

# Disable
Function DisableDeactivationOlderPowershell2 {
	Write-Output "Activation des anciennes versions de Powershell(2)"
	Enable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root
}





################################################################

### Désactivation de l'utilisation de PowerShell à distance
#PAS ENCORE FAIT

# Enable

Function EnableDeactivationRemotePowershell {
	Write-Output "Désactivation de l'utilisation de PowerShell à distance"
	Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root
}


# Disable

Function DisableDeactivationRemotePowershell {
	Write-Output "Activation de l'utilisation de PowerShell à distance"
	Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root
}




























# Export functions
Export-ModuleMember -Function *

