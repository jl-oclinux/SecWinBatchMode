
# Test Custom Variables
If (!(Test-Path -LiteralPath ".\Custom-VarOverload.psm1") -And !(Test-Path -LiteralPath ".\Custom-VarAutodel.psm1")) {
	Write-Output "You must have a Custom-VarOverload.psm1 configuration file"
	Write-Output "(or Custom-VarAutodel.psm1) in the current folder to define"
	Write-Output "credentials for uninstalling Kaspersky Endpoint software."
	Exit
}

# Import module
Import-Module SWMB.psm1
Import-Module Custom.psm1
Import-Module Experimental.psm1

# Initialize
SWMB_Init

# Load one tweak (can be called multiple times)
# Unloads the tweak if it starts with the exclamation mark (!)
SWMB_AddOrRemoveTweak "UninstallKasperskyEndpoint"

# Execute all loaded tweaks (presets)
SWMB_RunTweaks
