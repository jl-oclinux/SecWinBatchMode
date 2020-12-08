## Commandes PowerShell bitlocker
# https://docs.microsoft.com/en-us/powershell/module/bitlocker/?view=win10-ps

### Informations
Write-Host "Get-Disk informations"
Get-Disk

Write-Host "Get-TPM informations"
Get-TPM

### Activation
Write-Host "Code PIN :"
$Secure = Read-Host -AsSecureString

Write-Host "Enable bitlocker on C:"
Enable-BitLocker -MountPoint "C:" -TpmAndPinProtector -Pin $Secure -EncryptionMethod "XtsAes256"

Write-Host "Add key"
Add-BitLockerKeyProtector -MountPoint "c:" -RecoveryPasswordProtector

Write-Host "Resume disk c"
Resume-BitLocker -MountPoint "C:"

Write-Host "Copy key on c:"
(Get-BitLockerVolume -MountPoint C).KeyProtector > c:\"$env:computername"-bitlockerRecoveryKey.txt


If ((Test-Path D:))
{
  Write-Host "Enable bitlocker on D:"
  Enable-BitLocker -MountPoint "D:" -RecoveryPasswordProtector -EncryptionMethod "XtsAes256"

  Write-Host "Resume disk d"
  Resume-BitLocker -MountPoint "D:"

  Write-Host "Copy key on c:"
  (Get-BitLockerVolume -MountPoint D).KeyProtector > c:\"$env:computername"-bitlockerRecoveryKey-D.txt
  ## Auto unlock D mais ne fonctionne pas avant reboot
  # après reboot
  # Unlock-BitLocker -MountPoint "D:" -recoverypassword xxxxx
  # Enable-BitLockerAutoUnlock -MountPoint "D:"
}
