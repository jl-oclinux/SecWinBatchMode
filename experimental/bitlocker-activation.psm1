Function EnableBitlocker {
	## PowerShell bitlocker commands
	# https://docs.microsoft.com/en-us/powershell/module/bitlocker/?view=win10-ps

	Function _NetworkKeyBackup() {
		Param (
			[Parameter(Mandatory = $true)] [string]$wantToSave
		)

		if ($wantToSave -eq $false) {
			do {
				$isNetWorkBackup = Read-Host "Do you want to save recovery key on a network drive [Y/N]?"
			} until ("Y", "N" -ccontains $isNetWorkBackup)
			if ($isNetWorkBackup -eq "N") {
				return $null
			}
		}

		do {
			$networkKeyBackup = Read-Host "Provide a CIFS/SMB writable network path with syntax \\serverName\SharedFolder"
		} until (($networkKeyBackup.Length -gt 2) -and ("\\" -ccontains $networkKeyBackup.Substring(0, 2)))

		if ($networkKeyBackup.Substring($networkKeyBackup.Length - 1) -ne "\") {
			$networkKeyBackup += "\"
		}
		try {
			New-Item -Name isWriteAllowed.txt -ItemType File -Path $networkKeyBackup -Force -ErrorAction stop | Out-Null
			return $networkKeyBackup
			# Todo question : do I delete the file afterwards?
		}
		catch {
			Write-Host ("$networkKeyBackup is not writable! Choose another location!") -ForegroundColor Red
			_NetworkKeyBackup -wantToSave $true
		}
	}

	Function _EncryptSytemDrive() {
		$title = 'Activation bitlocker'
		$query = 'Do you want to use PIN?'
		$choices = '&Yes', '&No'
		$decision = $Host.UI.PromptForChoice($title, $query, $choices, 1)
		if ($decision -eq 0) {
			Write-Host "Code PIN :"
			$secure = Read-Host -AsSecureString
			Write-Host "Enable bitlocker on system drive $systemDrive"
			Enable-BitLocker -MountPoint "$systemDrive" -TpmAndPinProtector -Pin $secure -EncryptionMethod "XtsAes256" 3> $null
		}
		else {
			Write-Host "Enable bitlocker on system drive $systemDrive without PIN"
			Enable-BitLocker -MountPoint "$systemDrive" -TpmProtector -EncryptionMethod "XtsAes256"
		}

		Write-Host "Add system drive key"
		Add-BitLockerKeyProtector -MountPoint "$systemDrive" -RecoveryPasswordProtector
		Write-Host "Copy system drive key on $systemDrive"
		$pathKey = $systemDrive + "\" + $Env:ComputerName + "-bitlockerRecoveryKey-" + $dateNow + "-" + $systemDriveLetter + ".txt"
		if (Test-Path -Path $pathKey -PathType leaf) {
			$oldKey = $systemDrive + "\" + $Env:ComputerName + "-bitlockerRecoveryKey-" + $dateNow + "-" + $systemDriveLetter + ".txt.old"
			Write-Host "Warning: $pathKey already exist => rename with .old extension"
			if (Test-Path -Path $oldKey -PathType leaf) {
				Write-Host "Warning: delete before old key $oldKey"
				Remove-Item -Path $oldKey -Force
			}
			Rename-Item -Path $pathKey -NewName $oldKey
		}
		(Get-BitLockerVolume -MountPoint $systemDriveLetter).KeyProtector > $pathKey
		# acl on key see https://stackoverflow.com/a/43317244
		icacls.exe $pathKey /Reset
		icacls.exe $pathKey /Grant:r "$((Get-Acl -Path $pathKey).Owner):(R)"
		icacls.exe $pathKey /InheritanceLevel:r

		# copy key if $networkKeyBackup
		if (-not ([string]::IsNullOrEmpty($networkKeyBackupFolder))) {
			Copy-Item $pathKey -Destination $networkKeyBackup
		}
	}

	# We treat all partitions that have an associated letter and that are of type fixed
	# ie we don't take into account the usb keys
	Function _EncryptNonSytemDrives() {
		# Other drives encryption
		$listVolume = Get-volume | Where-Object { $_.DriveType -eq "Fixed" -and $_.DriveLetter -ne $systemDriveLetter }
		foreach ($volume in $listVolume) {
			if (-not ($volume.DriveLetter)) { continue }

			$letter = $volume.DriveLetter
			$letterColon = $letter + ":"
			#if (Test-Path $letter){
			$CryptDrive = Read-Host -Prompt "The drive $letter is not removable and hosts a file system. Do you want to active Bitlocker on this drive? [Y/N]"
			if ($CryptDrive -ne "Y") { continue }

			# Test if partition is already encrypted (like for C:)
			if ((Get-BitLockerVolume $letter).ProtectionStatus -eq "on") {
				Write-Host "Bitlocker on drive $letter is already ON!"
				continue
			}

			Write-Host "Bitlocker activation on drive $letter is going to start"

			Enable-BitLocker -MountPoint $letter -RecoveryPasswordProtector -EncryptionMethod "XtsAes256" 3> $null
			Resume-BitLocker -MountPoint $letter

			Write-Host "Copy drive $letter key"
			$backupFile = $systemDrive + "\" + $Env:ComputerName + "-bitlockerRecoveryKey-" + $dateNow + "-" + $letter + ".txt"
			Write-Host $backupFile
			(Get-BitLockerVolume -MountPoint $letterColon).KeyProtector > $backupFile

			icacls.exe $backupFile /Reset
			icacls.exe $backupFile /Grant:r "$((Get-Acl -Path $backupFile).Owner):(R)"
			icacls.exe $backupFile /InheritanceLevel:r
			Write-Host "Bitlocker activation on drive $letter ended with success"

			# AutoUnlock
			if ((Get-BitLockerVolume $Env:SystemDrive).ProtectionStatus -eq "on") {
				Enable-BitLockerAutoUnlock -MountPoint $letter
			}
			else {
				$trigger = New-ScheduledTaskTrigger -AtStartup
				$user    = "NT AUTHORITY\SYSTEM"
				$key_obj = (Get-BitLockerVolume -MountPoint $letter).KeyProtector | Where-Object {$_.KeyProtectorType -eq 'RecoveryPassword'} | select-object -Property RecoveryPassword
			 	$key     = $key_obj.RecoveryPassword
				$action  = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command &{Unlock-BitLocker -MountPoint $letter -RecoveryPassword $key ; Enable-BitLockerAutoUnlock -MountPoint $letter ; Unregister-ScheduledTask task0  -confirm:`$false}"
				Register-ScheduledTask -Force -TaskName task0 -Trigger $trigger -User $user -Action $action -RunLevel Highest
			}

			# copy key if $networkKeyBackup
			if (-not ([string]::IsNullOrEmpty($networkKeyBackupFolder))) {
				Copy-Item $pathKey -Destination $networkKeyBackup
			}
		}
	}

	Function _EnforceCryptGPO() {
		# All registry keys :
		# https://getadmx.com/HKLM/Software/Policies/Microsoft/FVE
		if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE")) {
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
	$dateNow           = (Get-Date).ToString("yyyyMMddhhmm")
	$systemDrive       = $Env:SystemDrive
	$systemDriveLetter = $systemDrive.Substring(0, 1)

	if (!(Confirm-SecureBootUEFI)) {
		Write-Error "SecureBoot is OFF!"
		return
	}
	if (!(Get-Tpm).TpmReady) {
		Write-Host "Get-TPM informations"
		Get-Tpm
		Write-Error "TPM not ready!"
		return
	}

	# BEGIN GPO
	_EnforceCryptGPO

	$sytemDriveStatus = (Get-BitLockerVolume $systemDrive).VolumeStatus

	if ($sytemDriveStatus -eq "DecryptionInProgress") {
		Write-Error "Bitlocker decryption on $systemDrive is in progress!"
		return
	}

	Write-Host "Bitlocker Volume Status encryption on $systemDrive is $sytemDriveStatus"

	if (((Get-BitLockerVolume $Env:SystemDrive).ProtectionStatus -eq "On") -or ($sytemDriveStatus -eq "EncryptionInProgress")) {
		Write-Host "Bitlocker on system drive is already on (or in progress)"
		_EncryptNonSytemDrives
	}
	else {
		_EncryptSytemDrive
		_EncryptNonSytemDrives
	}

	# Save keys on a network path
	# $networkKeyBackupFolder = _NetworkKeyBackup -wantToSave $false

	$reboot = Read-Host -Prompt "Computer must be rebooted. Restart now ? [Y/n]"
	if ($reboot -ne "n") {
		Restart-Computer -Force
	}
}
