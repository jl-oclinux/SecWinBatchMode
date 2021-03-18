### Bitlocker ###

# All registry keys :
# https://getadmx.com/HKLM/Software/Policies/Microsoft/FVE

### Configuration

if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE")) {
New-Item -path "HKLM:\SOFTWARE\Policies\Microsoft\" -name "FVE"
}

# 256 bits# XTS-AES 256-bit
# https://admx.help/?Category=MDOP&Policy=Microsoft.Policies.BitLockerManagement::BLEncryptionMethodWithXts_Name

# encryption method for operating system drives
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "EncryptionMethodWithXtsOs" -Value 7
# encryption method for fixed data drives
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "EncryptionMethodWithXtsFdv" -Value 7
# encryption method for removable data drives
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "EncryptionMethodWithXtsRdv" -Value 7

# additional authentication at startup
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.VolumeEncryption::ConfigureAdvancedStartup_Name
# If you enable this policy setting, users can configure advanced startup options in the BitLocker setup wizard.
# If you disable or do not configure this policy setting, users can configure only basic options on computers with a TPM.
##### useless ?
# active this GPO
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseAdvancedStartup" -Value 1
# Don't allow bitlocker without TPM
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "EnableBDEWithNoTPM" -Value 0
# Dont allow =>0, allow =>2, require=>1
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPM" -Value 2
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMPIN" -Value 2
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMKey" -Value 2
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMKeyPIN" -Value 2

# Désactiver le changement de PIN par un utilisateur standard
# https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.VolumeEncryption::DisallowStandardUsersCanChangePIN_Name
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "DisallowStandardUserPINReset" -Value 1

# méthode de recouvrement autorisée
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.VolumeEncryption::OSRecoveryUsage_Name
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSRecovery" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSManageDRA" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSRecoveryPassword" -Value 2
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSRecoveryKey" -Value 2
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSHideRecoveryPage" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSActiveDirectoryBackup" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSActiveDirectoryInfoToStore" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "OSRequireActiveDirectoryBackup" -Value 0
