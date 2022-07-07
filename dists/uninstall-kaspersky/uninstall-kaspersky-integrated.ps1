
# Test Custom Variables
If (!(Test-Path -LiteralPath ".\Custom-VarOverload.psm1") -And !(Test-Path -LiteralPath ".\Custom-VarAutodel.psm1")) {
	Write-Output "You must have a Custom-VarOverload.psm1 configuration file"
	Write-Output "(or Custom-VarAutodel.psm1) in the current folder to define"
	Write-Output "credentials for uninstalling Kaspersky Endpoint software."
	Write-Output "You can use the script set-password-encrypted.ps1 to help"
	Write-Output "you create this module."
	Exit
}

# Launch SWMB
. "${Env:ProgramFiles}\SWMB\swmb.ps1" UninstallKasperskyEndpoint ViewKasperskyProduct
