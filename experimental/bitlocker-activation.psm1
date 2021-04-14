
Function EnableBitlocker {
	## PowerShell bitlocker commands
	# https://docs.microsoft.com/en-us/powershell/module/bitlocker/?view=win10-ps

	Function _NetworkKeyBackup() {
		Param (
			[Parameter(Mandatory=$true)] [string]$wantToSave
		)

		if ($wantToSave -eq $false) {
			do {
				$isNetWorkBackup = Read-Host "Do you want to save recovery key on a network drive [Y/N]?"
			} until ("Y","N" -ccontains $isNetWorkBackup)
			if ($isNetWorkBackup -eq "N") {
				return $null
			}
		}

		do {
			$networkKeyBackup = Read-Host "Provide a CIFS/SMB writable network path with syntax \\serverName\SharedFolder"
		} until (($networkKeyBackup.Length -gt 2) -and ("\\" -ccontains $networkKeyBackup.Substring(0,2)))

		if ($networkKeyBackup.Substring($networkKeyBackup.Length -1) -ne "\") {
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


	# Begin function
	$systemDrive = $Env:SystemDrive
	$systemDriveLetter = $systemDrive.Substring(0,1)

	if (!(Confirm-SecureBootUEFI)) {
		Write-Error "SecureBoot is OFF!"
		return
	}

	if ((Get-BitLockerVolume $Env:SystemDrive).ProtectionStatus -eq "on") {
		Write-Error "Bitlocker on $Env:SystemDrive is already ON!"
		return
	}

	if ((Get-BitLockerVolume $Env:SystemDrive).VolumeStatus -eq "EncryptionInProgress") {
		Write-Error "Bitlocker encryption on $Env:SystemDrive is in progress!"
		return
	}

	if ((Get-BitLockerVolume $Env:SystemDrive).VolumeStatus -eq "DecryptionInProgress") {
		Write-Error "Bitlocker decryption on $Env:SystemDrive is in progress!"
		return
	}

	if (!(Get-Tpm).TpmReady) {
		Write-Host "Get-TPM informations"
		Get-Tpm
		Write-Error "TPM not ready!"
		return
	}

	# Save keys on a network path
	$networkKeyBackupFolder = _NetworkKeyBackup -wantToSave $false


	# BEGIN GPO
	# All registry keys :
	# https://getadmx.com/HKLM/Software/Policies/Microsoft/FVE
	if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE")) {
	New-Item -path "HKLM:\SOFTWARE\Policies\Microsoft\" -name "FVE"
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
	# END GPO
	# Update GPO
	gpupdate

	# Test of the rights on the path

	$title    = 'Activation bitlocker'
	$query    = 'Do you want to use PIN?'
	$choices  = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice($title, $query, $choices, 1)
	if ($decision -eq 0) {
		Write-Host "Code PIN :"
		$secure = Read-Host -AsSecureString

		Write-Host "Enable bitlocker on $systemDrive"
		Enable-BitLocker -MountPoint "$systemDrive" -TpmAndPinProtector -Pin $secure -EncryptionMethod "XtsAes256"
	}
	else {
		Write-Host "Enable bitlocker on $systemDrive without PIN"
		Enable-BitLocker -MountPoint "$systemDrive" -TpmProtector -EncryptionMethod "XtsAes256"
	}

	Write-Host "Add key"
	Add-BitLockerKeyProtector -MountPoint "$systemDrive" -RecoveryPasswordProtector

	Write-Host "Copy key on $systemDrive"
	$pathKey = "C:\$Env:ComputerName-bitlockerRecoveryKey-C.txt"
	if (Test-Path -Path $pathKey -PathType leaf)
	{
		$oldKey = "C:\$Env:ComputerName-bitlockerRecoveryKey-C.txt.old"
		Write-Host "$pathKey already exist => rename with .old extension"
		Rename-Item -Path $pathKey -NewName $oldKey
	}
	(Get-BitLockerVolume -MountPoint C).KeyProtector > $pathKey
	# acl on key see https://stackoverflow.com/a/43317244
	icacls.exe $pathKey /Reset
	icacls.exe $pathKey /Grant:r "$((Get-Acl -Path $pathKey).Owner):(R)"
	icacls.exe $pathKey /InheritanceLevel:r

	###TODO boucle sur les lecteurs
	###If ((Test-Path D:))
	###{
	###  $bitOnDriveD = Read-Host -Prompt 'Drive D: exist, do you like to activate bitlocker on drive D: ? [yes/no] (default is no)'
	###  if ($bitOnDriveD -eq "yes") {
	###    Write-Host "Enable bitlocker on D:"
	###    Enable-BitLocker -MountPoint "D:" -RecoveryPasswordProtector -EncryptionMethod "XtsAes256"
	###    Write-Host "Resume disk d"
	###    Resume-BitLocker -MountPoint "D:"
	###    Write-Host "Copy key"
	###    (Get-BitLockerVolume -MountPoint D).KeyProtector > c:\"$Env:ComputerName"-bitlockerRecoveryKey-D.txt
	###    ## Auto unlock D mais ne fonctionne pas avant reboot
	###    # après reboot
	###    # Unlock-BitLocker -MountPoint "D:" -recoverypassword xxxxx
	###    # Enable-BitLockerAutoUnlock -MountPoint "D:"
	###  }
	### }

	# We treat all partitions that have an associated letter and that are of type fixed
	# ie we don't take into account the usb keys

	$listVolume = Get-volume | Where-Object {$_.DriveType -eq "Fixed" -and $_.DriveLetter -ne $systemDriveLetter }
	foreach ($volume in $listVolume) {
		if (-not ($volume.DriveLetter)) { continue }

		$letter = $volume.DriveLetter
		$letterColon = $letter + ":"
		#if (Test-Path $letter){
		$CryptDrive = Read-Host -Prompt "The drive $letter is not removable and hosts a file system. Do you want to active Bitlocker on this drive? [Y/N]"
		if ($CryptDrive -ne "Y") { continue }

		# Test if partition is already encrypted (like for C:)
		if ((Get-BitLockerVolume $letter).ProtectionStatus -eq "on") {
			Write-Host "Bitlocker on $letter is already ON!"
			continue
		}

		Write-Host "Bitlocker activation on drive $letter is going to start"
		##TODO
		# To add copy of the key on network if $networkKeyBackupFolder = true
		Enable-BitLocker -MountPoint $letter -RecoveryPasswordProtector -EncryptionMethod "XtsAes256"
		Resume-BitLocker -MountPoint $letter

		# Enable-BitLockerAutoUnlock -MountPoint $letter
		# impossible tant que le volume system n'est pas chiffré
		# Possible de faire une tache programmée
		# $Trigger= New-ScheduledTaskTrigger -AtStartup
		# $User= "NT AUTHORITY\SYSTEM"
		# $key_obj = (Get-BitLockerVolume -MountPoint $letter).keyprotector | Where-Object {$_.KeyProtectorType -eq 'RecoveryPassword'} | select-object -Property RecoveryPassword
		# $key = $key_obj.RecoveryPassword
		# $Action= New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-command &{Unlock-BitLocker -MountPoint $letter -RecoveryPassword $key ; Enable-BitLockerAutoUnlock -MountPoint $letter}"
		# Register-ScheduledTask -Force -TaskName "AutoUnlock Bitlocker for drive $letter" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest

		Write-Host "Copy key"
		$backupFile = $systemDrive + "\" + $Env:ComputerName + "-bitlockerRecoveryKey-" + $letter + ".txt"
		Write-Host $backupFile
		(Get-BitLockerVolume -MountPoint $letterColon).KeyProtector > $backupFile

		#$NextVolume = Read-Host -Prompt "Voulez vous chiffre un autre lecteur ? [O/N]"
		#if ($NextVolume -ne 'O'){
		#Write-Host "Chiffrement BitLocker termine pour tous les lecteurs"
		#exit
		#}
		Write-Host "Bitlocker activation on drive $letter ended with success"
	}
	Write-Host "Bitlocker script ended with success!"

	$reboot = Read-Host -Prompt "Computer must be rebooted. Restart now ? [Y/n]"
	if ($reboot -ne "n") {
		Restart-Computer -Force
	}
}
