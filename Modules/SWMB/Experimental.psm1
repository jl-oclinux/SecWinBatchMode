################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2022, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
# Authors:
#  2020 - Olivier de Marchi (Grenoble INP / LEGI)
#  2020 - David Gras (CNRS / DR11)
#  2020 - Clément Deiber (CNRS / DR11)
#  2020 - Gabriel Moreau (CNRS / LEGI)
################################################################

################################################################

################################################################

# ClearPageFileAtShutdown
# https://deployadmin.com/2019/11/03/vider-le-fichier-dechange-a-chaque-arret-de-windows/
# Enable
Function TweakEnableClearPageFile { # RESINFO
	Write-Output "Clear PageFile.sys at shutdown..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 1
}

# Disable
Function TweakDisableClearPageFile { # RESINFO
	Write-Output "Do not reset PageFile.sys at shutdown..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
}

# View
Function TweakViewClearPageFile { # RESINFO
	Write-Output 'Clear PageFile.sys (0 nothing enable, 1 clear at shutdown)'
	$KeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
	Get-ItemProperty -Path $KeyPath -Name "ClearPageFileAtShutdown"
}

# Set a target version
# https://docs.microsoft.com/en-us/windows/release-health/release-information
# If you don't update this policy before the device reaches end of service, the device will automatically be updated once it is 60 days past end of service for its version.
# If you specify a TargetReleaseVersion the same as the current version, Windows 10 will stay on this version until it reaches end of service.
# If you specify a TargetReleaseVersion higher than the current version, Windows 10 will directly update only to the specified version even if a higher version is available.
# Enable
Function TweakSetTargetRelease { # RESINFO
	Write-Output "Set Target Release to $($Global:SWMB_Custom.TargetReleaseVersionInfo)..."
	Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name "ProductVersion" -value  $Global:SWMB_Custom.ProductVersion -Type String -Force
	Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name "TargetReleaseVersion" -value '00000001' -Type DWord -Force
	Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name "TargetReleaseVersionInfo" -value $Global:SWMB_Custom.TargetReleaseVersionInfo -Type String -Force
}

# Disable
Function TweakUnsetTargetRelease { # RESINFO
	Write-Output "No Target Release..."
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name "ProductVersion" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name "TargetReleaseVersion" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name "TargetReleaseVersionInfo" -ErrorAction SilentlyContinue
}

# View
Function TweakViewTargetRelease { # RESINFO
	Write-Output 'Target Release (nothing = no target release)'
	Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name "TargetReleaseVersionInfo" -ErrorAction SilentlyContinue
}

Function TweakRemoveKasperskyEndpoint { # RESINFO
	# Todo
	# test on KesKeyFile

	$kes = Get-WmiObject win32_product | Where { $_.Name -like "*Kaspersky endpoint security*" }

	if ($kes.IdentifyingNumber) {
	  Write-Host "Uninstalling Kaspersky version $($kes.Version) with guid => $($kes.IdentifyingNumber)"
	  if ($Global:SWMB_Custom.KesPassword) {
	    # mot de passe défini en clair
	    $PlainPassword = $Global:SWMB_Custom.KesPassword
	  }
	  elseif ($Global:SWMB_Custom.KesSecureString) {
	    # mot de passe chiffré
	    $password = $Global:SWMB_Custom.KesSecureString | ConvertTo-SecureString -Key (Get-Content $Global:SWMB_Custom.KesKeyFile)
	    $credential = New-Object System.Management.Automation.PsCredential($Global:SWMB_Custom.KesLogin,$password)
	    $PlainPassword = $credential.GetNetworkCredential().Password
	  }
	  else {
	    # Interactif - mot de passe demandé
	    $PlainPassword = Read-Host -AsSecureString -Prompt "Give the Kaspersky endpoint password for $($Global:SWMB_Custom.KesLogin)"
	  }

	### uninstall
	  $MSIArguments = @(
	    "/x"
	    $kes.IdentifyingNumber
	    "KLLOGIN=$($Global:SWMB_Custom.KesLogin)"
	    "KLPASSWD=$PlainPassword"
	    "/norestart"
	    "/qn"
	  )
	  Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow
	  Write-Host "Uninstall finish"
	}

	else {
	  Write-Host "Kaspersky not installed on this computer"
	}
}



################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
