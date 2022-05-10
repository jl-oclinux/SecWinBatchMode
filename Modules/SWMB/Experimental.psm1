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

################################################################

# Suppress Kaspersky Endpoint software
# Uninstall
Function TweakUninstallKasperskyEndpoint { # RESINFO

	Function _String2Hex {
		Param (
			[Parameter(Mandatory = $true)] [string]$Text
		)

		$CharArray=$Text.ToCharArray()
		ForEach ($Char in $CharArray) {
			$TextHex = $TextHex + " " + [System.String]::Format("{0:x2}", [System.Convert]::ToUInt32($Char))
		}
		Return $TextHex
	}

	Write-Output "Suppress software Kaspersky Endpoint protection..."

	# Remove Kaspersky Endpoint
	$KesEndpoint = Get-WmiObject win32_product | Where { $_.Name -like "*Kaspersky Endpoint Security*" }
	If ($KesEndpoint.IdentifyingNumber) {
		Write-Host "Uninstalling Kaspersky version $($KesEndpoint.Version) with GUID => $($KesEndpoint.IdentifyingNumber)"
		$PlainPassword=''
		If ($($Global:SWMB_Custom.KesPassword)) {
			# Batch - password defined in clear text
			$PlainPassword = $($Global:SWMB_Custom.KesPassword)
		} ElseIf (($($Global:SWMB_Custom.KesSecureString)) -And (Test-Path -LiteralPath "$($Global:SWMB_Custom.KesKeyFile)")) {
			# Batch - encrypted (blurred) password
			$CryptPassword = $($Global:SWMB_Custom.KesSecureString) | ConvertTo-SecureString -Key (Get-Content $($Global:SWMB_Custom.KesKeyFile))
			$Credential = New-Object System.Management.Automation.PsCredential($($Global:SWMB_Custom.KesLogin),$CryptPassword)
			$PlainPassword = $Credential.GetNetworkCredential().Password
		}

		# Uninstall
		$MSIArguments = @(
			"/x"
			$KesEndpoint.IdentifyingNumber
			"KLLOGIN=$($($Global:SWMB_Custom.KesLogin))"
			"KLPASSWD=$PlainPassword"
			"/norestart"
			"/qn"
		)
		Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow
		Write-Host "Uninstall finish"
	} Else {
		Write-Host "Kaspersky Endpoint is not installed on this computer"
	}

	# Remove Kaspersky Agent, French GUID = {2924BEDA-E0D7-4DAF-A224-50D2E0B12F5B}
	$KesAgent = Get-WmiObject win32_product | Where { $_.Name -like "*Agent*Kaspersky Security Center*" }
	If ($KesAgent.IdentifyingNumber) {
		Write-Output "Suppress Agent Kaspersky Security Center $($KesAgent.Version) with GUID => $($KesAgent.IdentifyingNumber)"
		Start-Process "msiexec.exe" -ArgumentList "/x $($KesAgent.IdentifyingNumber) /qn" -Wait -NoNewWindow
		}
	Else {
		Write-Host "Kaspersky Agent Security Center is not installed on this computer "
	}
}

################################################################

# Suppress Kaspersky Console software
# Uninstall
Function TweakUninstallKasperskyConsole { # RESINFO
	Write-Output "Uninstall software Kaspersky Console..."

	# Remove Kaspersky Console, French GUID = {5D35D57A-30B9-493B-819F-C6C2181A0A1A}
	$KesConsole = Get-WmiObject win32_product | Where { $_.Name -like "*Console*Kaspersky Security Center*" }
	If ($KesConsole.IdentifyingNumber) {
		Write-Output "Suppress Console Kaspersky Security Center..."
		Start-Process "msiexec.exe" -ArgumentList "/X $($KesConsole.IdentifyingNumber) /qn" -Wait -NoNewWindow
		Write-Host "Uninstall finish"
	} Else {
		Write-Host "Kaspersky Console is not installed on this computer"
	}
}

################################################################

# View all Kaspersky Product
# View
Function TweakViewKasperskyProduct { # RESINFO
	Write-Output "View all Kaspersky products..."
	# Warning if another Kaspersky is still installed on the computer
	Get-WmiObject win32_product | Where { $_.Name -like "*Kaspersky*" } | ForEach-Object {
		Write-Host "Note: Product $($_.IdentifyingNumber) is installed: $($_.Name)"
	}
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
