## Commandes PowerShell bitlocker

# script permettant de sauvegarder les protecteurs de clé dans un répertoire partagé
# Ici en exemple la partition C: Peut bien sur etre adapté à un autre lecteur ou un tableau de lecteur @("C:","D:",...)
# Les permissions sur le répertoire doivent être mises correctement.
# Je recommande accès lecture pour utilisateurs et ordinateurs et createur propriétaire
$repBackup = "chemin UNC repertoire backup"
$systemDrive = "C:"
$hostname = $env:COMPUTERNAME
$bitlockerVolume = Get-BitLockerVolume -MountPoint $systemDrive
$bitlockerVolumeStatus = $bitlockerVolume.volumeStatus
#chiffrement du volume systeme

#Add-BitLockerKeyProtector -MountPoint $systemDrive -RecoveryPasswordProtector
$protectorRecoveryPassword = $bitlockerVolume.KeyProtector | Where-Object {$_.KeyProtectorType -eq 'RecoveryPassword'}
   foreach ($kp in $protectorRecoveryPassword) {
      #if ($kp.KeyProtectorType.ToString() -eq "RecoveryPassword") {
      write-host $kp.KeyProtectorType.ToString()
      }
$fileBackup = $repBackup + "\" + $hostname + ".txt"

(Get-BitLockerVolume -MountPoint $systemDrive -ErrorAction Continue).KeyProtector > $fileBackup
