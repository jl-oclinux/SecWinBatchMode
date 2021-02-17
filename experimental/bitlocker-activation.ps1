Function EnableBitlocker {

## Commandes PowerShell bitlocker
# https://docs.microsoft.com/en-us/powershell/module/bitlocker/?view=win10-ps
$systemDrive = $env:systemdrive

if (!(Confirm-SecureBootUEFI)) {
   Write-Error "UEFI is OFF !" -ErrorAction Stop
}

if ((Get-BitLockerVolume $env:systemdrive).ProtectionStatus -eq "on") {
  Write-Error "Bitlocker on $env:systemdrive is already ON !" -ErrorAction stop
}

if (!(get-tpm).tpmready) {
  Write-Host "Get-TPM informations"
  Get-TPM
  Write-Error "TPM not ready !" -ErrorAction stop
}

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
  (Get-BitLockerVolume -MountPoint C).KeyProtector > c:\"$env:computername"-bitlockerRecoveryKey.txt
#TODO change les droits chmod go-rwx

} else {
    Write-Host 'without PIN'
#TODO procdure sans code PIN
}


#TODO boucle sur les lecteurs
If ((Test-Path D:))
{
  $bitOnDriveD = Read-Host -Prompt 'Drive D: exist, do you like to activate bitlocker on drive D: ? [yes/no] (default is no)'
  if ($bitOnDriveD -eq "yes") {
    Write-Host "Enable bitlocker on D:"
    Enable-BitLocker -MountPoint "D:" -RecoveryPasswordProtector -EncryptionMethod "XtsAes256"
    Write-Host "Resume disk d"
    Resume-BitLocker -MountPoint "D:"
    Write-Host "Copy key"
    (Get-BitLockerVolume -MountPoint D).KeyProtector > c:\"$env:computername"-bitlockerRecoveryKey-D.txt
    ## Auto unlock D mais ne fonctionne pas avant reboot
    # après reboot
    # Unlock-BitLocker -MountPoint "D:" -recoverypassword xxxxx
    # Enable-BitLockerAutoUnlock -MountPoint "D:"
  }
}

}
