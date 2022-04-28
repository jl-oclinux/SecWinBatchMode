
If (!(Test-Path -LiteralPath ".\Custom-VarOverload.psm1")) {
	Write-Output "You must have a Custom-VarOverload.psm1 configuration"
	Write-Output "file in the current folder to define credentials for"
	Write-Output "uninstalling Kaspersky Endpoint software."
	Exit
}

"${Env:ProgramFiles}\SWMB\swmb.ps1" -exp -import "${Env:ProgramFiles}\SWMB\Modules\SWMB\Custom.psm1" UninstallKasperskyEndpoint
