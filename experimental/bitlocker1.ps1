## Commandes PowerShell bitlocker

$hardware =  Get-WmiObject -class win32_computersystem
$systemDrive = "C:"

#desktop
if ($hardware.PCSystemType -eq 2) {
   #Bios UEFI et traitement de l'errreur
   $isUEFI = Confirm-SecureBootUEFI -ErrorVariable ProcessError
   if ($ProcessError -eq $true) {
      Write-Error "erreur accès bios" -ErrorAction Stop
   }
   else {
      $bitlockerVolume = Get-BitLockerVolume -MountPoint $systemDrive
      $bitlockerVolumeStatus = $bitlockerVolume.volumeStatus
      #chiffrement du volume systeme
      if ($bitlockerVolumeStatus -eq "FullyDecrypted") {
         Add-BitLockerKeyProtector -MountPoint $systemDrive -RecoveryPasswordProtector
         $protectorRecoveryPassword = $bitlockerVolume.KeyProtector | Where-Object {$_.KeyProtectorType -eq 'RecoveryPassword'}
         foreach ($kp in $protectorRecoveryPassword) {
            if ($kp.KeyProtectorType.ToString() -eq "RecoveryPassword") {
               Backup-BitLockerKeyProtector -MountPoint $systemDrive -KeyProtectorId $kp.KeyProtectorId
            }
         }
         Enable-BitLocker -MountPoint $systemDrive -TpmProtector
      }
   } 
}
