
$SWLN_Name = "SWLN"
$SWLN_Version = "4.6"
$SWMB_Version = "3.14.3.0"

If (Test-Path "${Env:ProgramFiles}\$SWLN_Name\version.txt" -PathType Leaf) {
	$SWLN_VersionOld = Get-Content -Path "${Env:ProgramFiles}\$SWLN_Name\version.txt"
	# $SWLN_VersionOld_number = [float]$SWLN_VersionOld
}

# Copy of scripts and configuration files
Copy-Item -LiteralPath 'install.bat'                     -Destination "${Env:ProgramFiles}\$SWLN_Name" -Force
Copy-Item -LiteralPath 'uninstall.bat'                   -Destination "${Env:ProgramFiles}\$SWLN_Name" -Force
Copy-Item -LiteralPath 'Local-Addon.psm1'                -Destination "${Env:ProgramFiles}\$SWLN_Name" -Force
Copy-Item -LiteralPath 'Custom-VarOverload.psm1'         -Destination "${Env:ProgramFiles}\$SWLN_Name" -Force
Copy-Item -LiteralPath 'CurrentUser-Logon.preset'        -Destination "${Env:ProgramFiles}\$SWLN_Name" -Force
Copy-Item -LiteralPath 'LocalMachine-Boot.preset'        -Destination "${Env:ProgramFiles}\$SWLN_Name" -Force
Copy-Item -LiteralPath 'LocalMachine-PostInstall.preset' -Destination "${Env:ProgramFiles}\$SWLN_Name" -Force
Copy-Item -LiteralPath 'logo-swmb.ico'                   -Destination "${Env:ProgramFiles}\$SWLN_Name" -Force
#Copy-Item -LiteralPath 'print'                  -Destination "${Env:ProgramFiles}\$SWLN_Name" -Recurse -Force

# Create main ProgramData folder (SWLN is installed before SWMB)
If (!(Test-Path -LiteralPath "${Env:ProgramData}\SWMB")) {
	New-Item -Path "${Env:ProgramData}\SWMB" -ItemType "directory" -Force
}

# Push config files in ProgramData before install SWMB
ForEach ($FileItem in @(
	"${Env:ProgramData}\SWMB\Presets\CurrentUser-Logon.preset"
	"${Env:ProgramData}\SWMB\Presets\LocalMachine-Boot.preset"
	"${Env:ProgramData}\SWMB\Presets\LocalMachine-PostInstall.preset"
	"${Env:ProgramData}\SWMB\Modules\Custom-VarOverload.psm1"
	"${Env:ProgramData}\SWMB\Modules\Local-Addon.psm1"
)) {
	$FileName   = Split-Path -Path "$FileItem" -Leaf
	$FolderName = Split-Path -Path "$FileItem" -Parent
	If (!(Test-Path -LiteralPath "$FolderName")) {
		New-Item -Path "$FolderName" -ItemType "directory" -Force
		}
	If (Test-Path -LiteralPath "${Env:ProgramFiles}\$SWLN_Name\$FileName") {
		If (Test-Path -LiteralPath "$FileItem") {
			Rename-Item -LiteralPath "$FileItem" -NewName ("$FileItem" + ".old") -Force -ErrorAction Ignore
		}
		Copy-Item -LiteralPath "${Env:ProgramFiles}\$SWLN_Name\$FileName" -Destination "$FileItem" -Force
	}
}

# Allow PowerShell scripts in the SWLN directory
Get-ChildItem -LiteralPath "${Env:ProgramFiles}\$SWLN_Name\"  -Recurse | Unblock-File
Get-ChildItem -LiteralPath "${Env:ProgramData}\SWMB\Modules\" -Recurse | Unblock-File

# Silent SWMB install
& .\SWMB-Setup-"$SWMB_Version".exe /S | Out-Null

# Creation of the version file with the version number
New-Item -Path "${Env:ProgramFiles}\$SWLN_Name\version.txt" -Type File -Force
$SWLN_Version | Set-Content -LiteralPath "${Env:ProgramFiles}\$SWLN_Name\version.txt"
