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
	Write-Output "Set Target Release..."
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

################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
