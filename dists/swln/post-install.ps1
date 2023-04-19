# execution powershell mode RemoteSigned
# Set-ItemProperty -Path "hklm:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name "ExecutionPolicy" -Value "RemoteSigned"

# Folder create
# If (!(Test-Path "${Env:ProgramFiles}\SWLN" -PathType container)) {
# New-Item -ItemType directory -path "${Env:ProgramFiles}" -name "SWLN"
# New-Item -ItemType directory -path "C:\Program Files\SWLN" -name "print"
# }

$SWLNVersion = "4.6"
$SWMBVersion = "3.14.3.0"

If (Test-Path "${Env:ProgramFiles}\SWLN\version.txt" -PathType Leaf) {
	$SWLNVersionOld = Get-Content -Path "${Env:ProgramFiles}\SWLN\version.txt"
	# $SWLNVersionOld_number = [float]$SWLNVersionOld
}

#copie des scripts
Copy-Item -LiteralPath 'install.bat'                     -Destination "${Env:ProgramFiles}\SWLN" -Force
Copy-Item -LiteralPath 'uninstall.bat'                   -Destination "${Env:ProgramFiles}\SWLN" -Force
Copy-Item -LiteralPath 'Local-Addon.psm1'                -Destination "${Env:ProgramFiles}\SWLN" -Force
Copy-Item -LiteralPath 'Custom-VarOverload.psm1'         -Destination "${Env:ProgramFiles}\SWLN" -Force
Copy-Item -LiteralPath 'CurrentUser-Logon.preset'        -Destination "${Env:ProgramFiles}\SWLN" -Force
Copy-Item -LiteralPath 'LocalMachine-Boot.preset'        -Destination "${Env:ProgramFiles}\SWLN" -Force
Copy-Item -LiteralPath 'LocalMachine-PostInstall.preset' -Destination "${Env:ProgramFiles}\SWLN" -Force
Copy-Item -LiteralPath 'logo-swmb.ico'                   -Destination "${Env:ProgramFiles}\SWLN" -Force
#Copy-Item -LiteralPath 'print'                  -Destination "${Env:ProgramFiles}\SWLN" -Recurse -Force

# Create main ProgramData folder (SWLN is installed before SWMB)
If (!(Test-Path -LiteralPath "$Env:ProgramData\SWMB")) {
	New-Item -Path "$Env:ProgramData\SWMB" -ItemType "directory" -Force
}

# Push in ProgramData before install SWMB
ForEach ($FileItem in @(
	"$Env:ProgramData\SWMB\Presets\CurrentUser-Logon.preset"
	"$Env:ProgramData\SWMB\Presets\LocalMachine-Boot.preset"
	"$Env:ProgramData\SWMB\Presets\LocalMachine-PostInstall.preset"
	"$Env:ProgramData\SWMB\Modules\Custom-VarOverload.psm1"
	"$Env:ProgramData\SWMB\Modules\Local-Addon.psm1"
)) {
	$FileName   = Split-Path -Path "$FileItem" -Leaf
	$FolderName = Split-Path -Path "$FileItem" -Parent
	If (!(Test-Path -LiteralPath "$FolderName")) {
		New-Item -Path "$FolderName" -ItemType "directory" -Force
		}
	If (Test-Path -LiteralPath "${Env:ProgramFiles}\SWLN\$FileName") {
		If (Test-Path -LiteralPath "$FileItem") {
			Rename-Item -LiteralPath "$FileItem" -NewName ("$FileItem" + ".old") -Force -ErrorAction Ignore
		}
		Copy-Item -LiteralPath "${Env:ProgramFiles}\SWLN\$FileName" -Destination "$FileItem" -Force
	}
}

# Allow PowerShell scripts in the SWLN directory
Get-ChildItem -LiteralPath "${Env:ProgramFiles}\SWLN\"    -Recurse | Unblock-File
Get-ChildItem -LiteralPath "${Env:ProgramData}\SWMB\Modules\" -Recurse | Unblock-File

# Silent SWMB install
& .\SWMB-Setup-"$SWMBVersion".exe /S | Out-Null

# Creation of the version file with the version number
New-Item -Path "${Env:ProgramFiles}\SWLN\version.txt" -Type File -Force
$SWLNVersion | Set-Content -LiteralPath "${Env:ProgramFiles}\SWLN\version.txt"
