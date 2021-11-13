#Requires -Version 4.0
#Requires -RunAsAdministrator


$gitUrl = "https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb/-/archive/master/resinfo-swmb-master.zip"
$swmbBitlockerDirectory = "C:\SWMB"

Write-Host @"
This script aims to configure Bitlocker on your computer (cf. README)
This script creates a $swmbBitlockerDirectory\resinfo-swmb-master subdirectory if not exsists
or delete it and recreate if exists
This script download the main script from gitlab.in2p3.fr
To work correctly, this script needs:
   - To be run with an administrator account and elevated privileges
   - BIOS in UEFI
   - SecureBoot enabled
   - TPM activated

"@ -ForegroundColor Green

$confirmation = Read-Host "Do you want to proceed? [y/N]"
if ($confirmation -ne "y") {
    Write-Host @"
------------------
Stop processing!
------------------
"@ -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

$outZipFile = Join-Path  -Path (Get-Location) -ChildPath swmb-bitlocker.zip

Write-Host @"
------------------
Processing directory $swmbBitlockerDirectory...
------------------
"@ -ForegroundColor Green

if (-not (Test-Path $swmbBitlockerDirectory)) {
    New-Item -Path $swmbBitlockerDirectory -ItemType Directory 
}
if (Test-Path "$swmbBitlockerDirectory\resinfo-swmb-master") {
    Remove-Item "$swmbBitlockerDirectory\resinfo-swmb-master" -Force -Recurse
}

Write-Host @"
------------------
Downloading file...
------------------
"@ -ForegroundColor Green
Invoke-WebRequest $gitUrl -OutFile $outZipFile -ErrorAction Stop


Write-Host @"
------------------
Decompressing file...
------------------
"@ -ForegroundColor Green
Expand-Archive -Path $outZipFile -DestinationPath $swmbBitlockerDirectory
if (-not (Test-Path "$swmbBitlockerDirectory\resinfo-swmb-master")) {
    Write-Host @"
------------------
Error decompressing. Stop script!
------------------
"@ -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

Write-Host @"
------------------
Unblocking files...
------------------
"@ -ForegroundColor Green
dir -Path "$swmbBitlockerDirectory\resinfo-swmb-master" -Recurse  | Unblock-File

Write-Host @"
------------------
Launching...
------------------
"@ -ForegroundColor Green

cd "$swmbBitlockerDirectory\resinfo-swmb-master"
& .\swmb.ps1 `
   SysRequireAdmin `
   EnableBitlocker
