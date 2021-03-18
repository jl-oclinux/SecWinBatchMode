
Function EnableBitlocker {
	## Commandes PowerShell bitlocker
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

		if ($networkKeyBackup.Substring($networkKeyBackup.length -1) -ne "\") {
			$networkKeyBackup += "\"
		}
		try {
			New-Item -Name isWriteAllowed.txt -ItemType File -Path $networkKeyBackup -Force -ErrorAction stop | Out-Null
			return $networkKeyBackup
			# todo question : est-ce que je supprime le fichier ensuite? bof...
		}
		catch {
			Write-Host ("$networkKeyBackup is not writable! Choose another location!") -ForegroundColor Red
			_NetworkKeyBackup -wantToSave $true
		}
	}


	# Begin function
	$systemDrive = $env:systemdrive
	$systemDriveLetter = $systemDrive.substring(0,1)

	if (!(Confirm-SecureBootUEFI)) {
		Write-Error "SecureBoot is OFF !"
		return
	}

	if ((Get-BitLockerVolume $env:systemdrive).ProtectionStatus -eq "on") {
		Write-Error "Bitlocker on $env:systemdrive is already ON !"
		return
	}

	if (!(Get-Tpm).TpmReady) {
		Write-Host "Get-TPM informations"
		Get-Tpm
		Write-Error "TPM not ready !"
		return
	}

	# sauvegarde des clefs sur un chemin reseau
	$networkKeyBackupFolder = _NetworkKeyBackup -wantToSave $false

	# Test des droits sur le chemin

	$title    = 'Activation bitlocker'
	$question = 'Do you want to use PIN?'
	$choices  = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)

	if ($decision -eq 0) {
		Write-Host "Code PIN :"
		$Secure = Read-Host -AsSecureString

		Write-Host "Enable bitlocker on $systemDrive"
		Enable-BitLocker -MountPoint "$systemDrive" -TpmAndPinProtector -Pin $Secure -EncryptionMethod "XtsAes256"

		Write-Host "Add key"
		Add-BitLockerKeyProtector -MountPoint "$systemDrive" -RecoveryPasswordProtector

		#Write-Host "Resume disk $systemDrive"
		#Resume-BitLocker -MountPoint "$systemDrive"

		Write-Host "Copy key on $systemDrive"
		$pathkey = "C:\$env:computername-bitlockerRecoveryKey-C.txt"
		(Get-BitLockerVolume -MountPoint C).KeyProtector > $pathkey
		# acl on key see https://stackoverflow.com/a/43317244
		icacls.exe $pathkey /reset
		icacls.exe $pathkey /GRANT:R "$((Get-Acl -Path $path).Owner):(R)"
		icacls.exe $pathkey /inheritance:r

	}
	else {
		Write-Host "Enable bitlocker on $systemDrive without PIN"
		Enable-BitLocker -MountPoint "$systemDrive" -TpmProtector -EncryptionMethod "XtsAes256"

		Write-Host "Add key"
		Add-BitLockerKeyProtector -MountPoint "$systemDrive" -RecoveryPasswordProtector

		#Write-Host "Resume disk $systemDrive"
		#Resume-BitLocker -MountPoint "$systemDrive"

		Write-Host "Copy key on $systemDrive"
		(Get-BitLockerVolume -MountPoint C).KeyProtector > C:\"$env:computername"-bitlockerRecoveryKey-C.txt
	}

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
	###    (Get-BitLockerVolume -MountPoint D).KeyProtector > c:\"$env:computername"-bitlockerRecoveryKey-D.txt
	###    ## Auto unlock D mais ne fonctionne pas avant reboot
	###    # après reboot
	###    # Unlock-BitLocker -MountPoint "D:" -recoverypassword xxxxx
	###    # Enable-BitLockerAutoUnlock -MountPoint "D:"
	###  }
	### }

	# On traite toutes les partitions qui ont une lettre associee et qui sont de type fixed
	# ie on ne prend pas en compte les clefs usb

	$List_volume = Get-volume | Where-Object {$_.DriveType -eq "Fixed" -and $_.DriveLetter -ne $systemDriveLetter }
	foreach ($volume in $List_volume) {
		if (-not ($volume.DriveLetter)) { continue }

		$Letter = $volume.DriveLetter
		$LetterColon = $letter + ":"
		#if (Test-Path $letter){
		$ChiffDrv = Read-Host -Prompt "The drive $letter is not removable and hosts a file system. Do you want to active Bitlocker on this drive ? [Y/N]"
		if ($ChiffDrv -ne "Y") { continue }

		Write-Host "Bitlocker activation on drive $letter is going to start"
		##TODO
		#A voir pourquoi on reteste pas si partition déja chiffree (comme pour C:)
		#A rajouter copie de la clef sur reseau si $networkKeyBackupFolder = true
		Enable-BitLocker -MountPoint $Letter -RecoveryPasswordProtector -EncryptionMethod "XtsAes256"
		Resume-BitLocker -MountPoint $Letter
		Write-Host "Copy key"
		$backupFile = $systemDrive + "\" + $env:computername + "-bitlockerRecoveryKey-" + $Letter + ".txt"
		Write-Host $backupFile
		(Get-BitLockerVolume -MountPoint $LetterColon).KeyProtector > $backupFile

		#$NextVolume = Read-Host -Prompt "Voulez vous chiffre un autre lecteur ? [O/N]"
		#if ($NextVolume -ne 'O'){
		#Write-Host "Chiffrement BitLocker termine pour tous les lecteurs"
		#exit
		#}
		Write-Host "Bitlocker activation on drive $letter ended with success"
	}
	Write-Host "Bitlocker script ended with success!"

	$reboot = Read-Host -Prompt "Computer must be restarted. Restart now ? [Y/n]"
	if ($reboot -ne "n") {
		Restart-Computer -Force
	}
}
