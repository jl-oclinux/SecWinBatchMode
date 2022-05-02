
If (!(Test-Path -LiteralPath ".\Custom-VarOverload.psm1") -And !(Test-Path -LiteralPath ".\Custom-VarAutodel.psm1")) {
	Write-Output "You must have a Custom-VarOverload.psm1 configuration file"
	Write-Output "(or Custom-VarAutodel.psm1) in the current folder to define"
	Write-Output "credentials for uninstalling Kaspersky Endpoint software."
	Exit
}

. "${Env:ProgramFiles}\SWMB\swmb.ps1" -exp -import "${Env:ProgramFiles}\SWMB\Modules\SWMB\Custom.psm1" UninstallKasperskyEndpoint
