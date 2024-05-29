################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2024, CNRS, France
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
	Write-Output "Enabling Clear PageFile.sys at shutdown..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 1
}

# Disable
Function TweakDisableClearPageFile { # RESINFO
	Write-Output "Disabling (do not) reset PageFile.sys at shutdown..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
}

# View
Function TweakViewClearPageFile { # RESINFO
	Write-Output "Viewing Clear PageFile.sys (0 nothing enable, 1 clear at shutdown)..."
	$KeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
	Get-ItemProperty -Path $KeyPath -Name "ClearPageFileAtShutdown"
}

################################################################

# Force reboot now if pending reboot
# Adapted from https://gist.github.com/altrive/5329377
# Based on <https://gallery.technet.microsoft.com/scriptcenter/Get-PendingReboot-Query-bdb79542>
# https://www.geekbits.io/how-to-view-a-pending-reboot-in-windows/
# https://stackoverflow.com/questions/47867949/how-can-i-check-for-a-pending-reboot
	Function _TestPendingReboot {
		# Check for 'Reboot Required' registry key
		If (Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue) { Return $True }

		# Check for 'Reboot Required' registry key
		If (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue) { Return $True }

	#	# Check for recent installation requiring reboot
	#	If (Test-Path "HKLM:\SOFTWARE\Microsoft\Updates\UpdateExeVolatile" -ErrorAction SilentlyContinue) { Return $True }

		# Check for System Center Configuration Manager
		If (Test-Path "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData" -ErrorAction SilentlyContinue) { Return $True }

	#	#Check for PendingFileRenameOperations
	#	If (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name 'PendingFileRenameOperations' -ErrorAction SilentlyContinue) { Return $True }

	#	Try {
	#		$Util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
	#		$Status = $Util.DetermineIfRebootPending()
	#		if(($Status -ne $Null) -and $Status.RebootPending){
	#			return $True
	#		}
	#	} Catch {}

		Return $False
	}

# View
Function TweakViewPendingReboot { # RESINFO
	Write-Output "Viewing Pending Reboot..."
	If (_TestPendingReboot) {
		Write-Output " reboot is needed"
	} Else {
		Write-Output " no reboot in queue"
	}
}

# Set
Function TweakSetPendingReboot { # RESINFO
	Write-Output "Setting Pending Reboot..."
	If (_TestPendingReboot) {
		Write-Output " reboot computer now..."
		Restart-Computer
	} Else {
		Write-Output " no reboot in queue"
	}
}

################################################################

Function TweakUninstallDELLSoftware { # RESINFO
	Write-Output "Uninstalling software DELL..."

	# msi soft
	Write-Output " Uninstalling DELL MSI software..."
	$InstalledMsi = Get-Package -ProviderName msi | Where-Object {$Global:SWMB_Custom.DellPackage -contains $_.Name}
	$InstalledMsi | ForEach-Object {
		Write-Host -Object " Attempting to uninstall this msi DELL package: [$($_.Name)]..."
		Try {
			$Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
			Write-Host -Object " Successfully uninstalled: [$($_.Name)]"
		} Catch {
			Write-Warning -Message " Failed to uninstall: [$($_.Name)]"
		}
	}

	# program soft
	Write-Output " Uninstalling DELL Programs software..."
	$InstalledPrograms = Get-Package -ProviderName Programs | Where-Object {$Global:SWMB_Custom.DellPackage -contains $_.Name}
	$InstalledPrograms | ForEach-Object {
		If (($_.Name -match "Dell SupportAssist OS Recovery Plugin for Dell Update") -Or ($_.Name -match "Dell Optimizer Core")) {
			Write-Host -Object " Attempting to uninstall: [$($_.Name)]..."
			Try {
				$Uninstallarray = $_.metadata['uninstallstring'] -Split '"'
				$Exe = $Uninstallarray[1].Trim()
				$arguments=$Uninstallarray[2].Trim()
				$arguments = $arguments+ " /silent"
				(Start-Process "$Exe" -ArgumentList $arguments -NoNewWindow -Wait -PassThru).ExitCode
				Write-Host -Object " Successfully uninstalled: [$($_.Name)]"
			} Catch {
				Write-Warning -Message " Failed to uninstall: [$($_.Name)]"
			}
		}
		If ($_.Name -match "Dell Peripheral Manager") {
			Write-Host -Object " Attempting to uninstall: [$($_.Name)]..."
			Try {
				$Uninstallarray = $_.metadata['uninstallstring'] -Split '"'
				$Exe = $Uninstallarray[1].Trim()
				$arguments = " /S"
				(Start-Process "$Exe" -ArgumentList $arguments -NoNewWindow -Wait -PassThru).ExitCode
				Write-Host -Object " Successfully uninstalled: [$($_.Name)]"
			} Catch {
				Write-Warning -Message " Failed to uninstall: [$($_.Name)]"
			}
		}
	}
}

################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function Tweak*
