################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2022, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
# Authors:
#  2020 - Olivier de Marchi (Grenoble INP / LEGI)
#  2020 - David Gras (CNRS / DR11)
#  2020 - Clément Deiber (CNRS / DR11)
#  2020 - Gabriel Moreau (CNRS / LEGI)
################################################################

# Variables utilisées dans le module Custom.psm1
# Ne modifier pas directement ce fichier !
# Vous pouvez surcharger ces variables en les redéfinissant dans un fichier Custom-VarOverload.psm1
# Exemple :
# $Global:SWMB_Custom.LocalAdminNameEffective = 'mysysadmin'

$Global:SWMB_Custom = @{
	# AdminAccountLogin
	LocalAdminNameEffective = "sas-swmb"
	LocalAdminNameOriginal  = "administrateur"

	# SessionLockTimeout
	InactivityTimeoutSecs  = 1200

	# SecurityParamAccountPolicy
	MinimumPasswordAge     = 1
	MaximumPasswordAge     = -1
	MinimumPasswordLength  = 12
	PasswordComplexity     = 1
	PasswordHistorySize    = 2
	LockoutBadCount        = 5
	ResetLockoutCount      = 30
	LockoutDuration        = 30
	EnableGuestAccount     = 0

	# NTP
	NTP_ManualPeerList     = "0.pool.ntp.org, 1.pool.ntp.org, 2.pool.ntp.org, 3.pool.ntp.org"

	# Target Release
	ProductVersion           = "Windows 10"
	TargetReleaseVersionInfo = "21H2"

	# Kaspersky Endpoint Security and Network Agent
	KesLogin     = "KLAdmin"
	KesPassword  = ""
	KesAgentPass = ""
	KesKeyFile   = ""

	# Workgroup Name
	WorkgroupName          = "WORKGROUP"
}
