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


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
