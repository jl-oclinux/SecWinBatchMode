Function Network-Key-Backup(){
    Param (
          [Parameter(Mandatory=$true)] [string]$wantToSave
      )

   if ($wantToSave -eq $false) {
      Do { $isNetWorkBackup = Read-Host "Do you want to save recovery key on a network drive [Y/N]?"
      } Until ("Y","N" -ccontains $isNetWorkBackup)
      if ($isNetWorkBackup -eq "N") {
         return $null
      }
   }

   Do {$networkKeyBackup = Read-Host "Provide a CIFS/SMB writable network path with syntax \\serverName\SharedFolder"
   } Until (($networkKeyBackup.Length -gt 2) -and ("\\" -ccontains $networkKeyBackup.Substring(0,2)))
   
   if ($networkKeyBackup.Substring($networkKeyBackup.length -1) -ne "\") {
      $networkKeyBackup += "\"
   }
   try {
      New-Item -Name isWriteAllowed.txt -ItemType File -Path $networkKeyBackup -Force -ErrorAction stop | Out-Null
      return $networkKeyBackup
      #todo question : est-ce que je supprime le fichier ensuite? bof...
   }
   catch {
      Write-Host ("$networkKeyBackup is not writable! Choose another location!") -ForegroundColor Red
      Network-Key-Backup -wantToSave $true 
   }
}


Function EnableBitlocker {

## Commandes PowerShell bitlocker
# https://docs.microsoft.com/en-us/powershell/module/bitlocker/?view=win10-ps
$systemDrive = $env:systemdrive
$systemDriveLetter = $systemDrive.substring(0,1)
$numVolume = 0

if (!(Confirm-SecureBootUEFI)) {
   Write-Error "UEFI is OFF !"
   return
}

if ((Get-BitLockerVolume $env:systemdrive).ProtectionStatus -eq "on") {
  Write-Error "Bitlocker on $env:systemdrive is already ON !"
  return
}

if (!(get-tpm).tpmready) {
  Write-Host "Get-TPM informations"
  Get-TPM
  Write-Error "TPM not ready !"
  return
}

#sauvegarde des clés sur un chemin réseau
$networkKeyBackupFolder = Network-Key-Backup -wantToSave $false

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

  Write-Host "Resume disk $systemDrive"
  Resume-BitLocker -MountPoint "$systemDrive"

  Write-Host "Copy key on $systemDrive"
  (Get-BitLockerVolume -MountPoint C).KeyProtector > c:\"$env:computername"-bitlockerRecoveryKey-c.txt
#TODO change les droits chmod go-rwx

}
else {
    Write-Host "Enable bitlocker on $systemDrive without PIN"
    Enable-BitLocker -MountPoint "$systemDrive" -TpmProtector -Pin $Secure -EncryptionMethod "XtsAes256"

    Write-Host "Add key"
    Add-BitLockerKeyProtector -MountPoint "$systemDrive" -RecoveryPasswordProtector

    Write-Host "Resume disk $systemDrive"
    Resume-BitLocker -MountPoint "$systemDrive"

    Write-Host "Copy key on $systemDrive"
    (Get-BitLockerVolume -MountPoint C).KeyProtector > c:\"$env:computername"-bitlockerRecoveryKey-c.txt
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
###    # aprÃ¨s reboot
###    # Unlock-BitLocker -MountPoint "D:" -recoverypassword xxxxx
###    # Enable-BitLockerAutoUnlock -MountPoint "D:"
###  }
### }

# On traite toutes les partitions qui ont une lettre associée et qui sont de type fixed
# ie on ne prend pas en compte les clés usb

$List_volume = Get-volume | Where-Object {$_.DriveType -eq "Fixed"  -and $_.DriveLetter -ne $systemDriveLetter }
$Nb_volume = $List_volume.count


do {
    $volume = $List_volume[$numVolume]
    if ($volume.DriveLetter) {
        $Letter = $volume.DriveLetter
		$LetterColon = $letter + ":"
        #if (Test-Path $letter){
        $ChiffDrv = Read-Host -Prompt "The drive $letter is not removable and hosts a file system. Do you want to active Bitlocker on this drive ? [Y/N]"
        if ($ChiffDrv -eq "Y") {
            Write-Host "Bitlocker activation on drive $letter is going to start"
			
			##TODO 
			#A voir pourquoi on reteste pas si partition déjà chiffrée (comme pour C:)
			#A rajouter copie de la clé sur réseau si $networkKeyBackupFolder = true
			Enable-BitLocker -MountPoint $letter -RecoveryPasswordProtector -EncryptionMethod "XtsAes256"
			Resume-BitLocker -MountPoint $letter
			Write-Host "Copy key"
			$backupFile = $systemDrive + "\" + $env:computername +"-bitlockerRecoveryKey-"+ $Letter + ".txt"
			write-host $backupFile
			(Get-BitLockerVolume -MountPoint $LetterColon).KeyProtector > $backupFile
                    
            #$NextVolume = Read-Host -Prompt "Voulez vous chiffre un autre lecteur ? [O/N]"
            #if ($NextVolume -ne 'O'){
            #Write-Host "Chiffrement BitLocker terminé pour tous les lecteurs"
            #exit
            #}
			Write-Host "Bitlocker activation on drive $letter ended with success"
        }
    }
    #} 
    $numVolume++
} until ($numVolume -eq $Nb_volume) 

write-host "Bitlocker script ended with success!"

}
