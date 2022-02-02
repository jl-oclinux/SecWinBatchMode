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
# 2022/02/02 - Enable is better
# ASLR (Address Space Layout Randomisation)
# Disable ASLR for Easier Malware Debugging
# Disable : HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\MoveImages and set its value to 0x00000000.
# https://oalabs.openanalysis.net/2019/06/12/disable-aslr-for-easier-malware-debugging/
# Disable
Function TweakDisableASLR { # RESINFO
	Write-Output "Turn off ASLR (Address Space Layout Randomisation)..."
	If (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management")) {
		New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "MoveImages" -Type DWord -Value 0
}

# Enable
Function TweakEnableASLR { # RESINFO
	Write-Output "Turn on ASLR (Address Space Layout Randomisation)..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "MoveImages" -ErrorAction SilentlyContinue
}

# View
Function TweakViewASLR { # RESINFO
	Write-Output 'ASLR (Address Space Layout Randomisation) (not exist - enable, 0 disable)'
	$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
		If ((Get-ItemProperty $Path -Name "MoveImages" -ea 0)."MoveImages" -ne $null) {
			Get-ItemProperty -Path $Path -Name "MoveImages"
		} Else {
			Write-Output "$Path name MoveImages not exist"
		}
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
