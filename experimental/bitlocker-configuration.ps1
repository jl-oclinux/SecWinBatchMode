### Bitlocker ###

# All registry keys :
# https://getadmx.com/HKLM/Software/Policies/Microsoft/FVE

### Configuration

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
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "EnableBDEWithNoTPM" -Value 0
# Dont allow =>0, allow =>2, require=>1
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPM" -Value 2
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMPIN" -Value 2
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMKey" -Value 2
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMKeyPIN" -Value 2

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
