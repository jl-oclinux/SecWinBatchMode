################################################################
# Win 10 / Server 2016 / Server 2019 SWMB Script - Main execution loop
# Project CNRS RESINFO SWMB
# Copyright (c) 2017-2020, Disassembler <disassembler@dasm.cz>
# Copyright (C) 2020-2023, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
# Authors:
#  2017 - Disassembler <disassembler@dasm.cz>
#  2023 - Gabriel Moreau (CNRS / LEGI)
# Version: v3.13, 2021-11-22
################################################################

Function ListSoftware {
	$Soft = @()
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
		ForEach {
			$Key = $_
			$App = (Get-ItemProperty -Path $Key.PSPath)
			$DisplayName    = $App.DisplayName
			$DisplayVersion = $App.DisplayVersion
			If ([string]::IsNullOrEmpty($DisplayName) -And [string]::IsNullOrEmpty($DisplayVersion)) { Return }

			$Publisher  = $App.Publisher
			$KeyProduct = $Key | Split-Path -Leaf
			$Exe = $App.UninstallString
			$Soft += New-Object PSObject -Property @{
				DisplayName    = $DisplayName
				DisplayVersion = $DisplayVersion
				KeyProduct     = $KeyProduct
				Publisher      = $Publisher
				UninstallExe   = $Exe
				Hive           = 'HKLM'
				#KeyPath        = $Key.Name
			}
		}

	@(Get-ChildItem -Recurse "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall") |
		ForEach {
			$Key = $_
			$App = (Get-ItemProperty -Path $Key.PSPath)
			$DisplayName    = $App.DisplayName
			$DisplayVersion = $App.DisplayVersion
			If ([string]::IsNullOrEmpty($DisplayName) -And [string]::IsNullOrEmpty($DisplayVersion)) { Return }

			$Publisher  = $App.Publisher
			$KeyProduct = $Key | Split-Path -Leaf
			$Exe = $App.UninstallString
			$Soft += New-Object PSObject -Property @{
				DisplayName    = $DisplayName
				DisplayVersion = $DisplayVersion
				KeyProduct     = $KeyProduct
				Publisher      = $Publisher
				UninstallExe   = $Exe
				Hive           = 'HKCU'
				#KeyPath        = $Key.Name
			}
		}

	$Soft | Select Hive,DisplayName,Publisher,DisplayVersion,KeyProduct,UninstallExe | Sort-Object -Property Hive,DisplayName
}

# GUI Output
ListSoftware | Out-GridView -Title 'LocalMachine and CurrentUser Software' -Wait


# Output in JSON Format
# ListSoftware | ConvertTo-Json
