################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020-2021, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb
# Authors:
#  2020 - Olivier de Marchi (Grenoble INP / LEGI)
#  2020 - David Gras (CNRS / DR11)
#  2020 - Clément Deiber (CNRS / DR11)
#  2020 - Gabriel Moreau (CNRS / LEGI)
################################################################

# Variables utilisées dans le module Custom.psm1
# Ne modifier pas directement ce fichier !
# Vous pouvez surcharger ces variables en les redéfinissant dans un fichier Custom-VarOverload.psm1

$myLocalAdminNameToSet = "sas-swmb"
$myLocalAdminNameOriginal = "administrateur"
$myInactivityTimeoutSecs = 1200

#Paramètres de sécurité
$MinimumPasswordAge = 1
$MaximumPasswordAge = -1
$MinimumPasswordLength = 12
$PasswordComplexity = 1
$PasswordHistorySize = 2
$LockoutBadCount = 5
$ResetLockoutCount = 30
$LockoutDuration = 30
$EnableGuestAccount = 0

Export-ModuleMember -Variable 'myLocalAdminNameToSet'
Export-ModuleMember -Variable 'myLocalAdminNameOriginal'
Export-ModuleMember -Variable 'myInactivityTimeoutSecs'

Export-ModuleMember -Variable 'MinimumPasswordAge'
Export-ModuleMember -Variable 'MaximumPasswordAge'
Export-ModuleMember -Variable 'MinimumPasswordLength'
Export-ModuleMember -Variable 'PasswordComplexity'
Export-ModuleMember -Variable 'PasswordHistorySize'
Export-ModuleMember -Variable 'LockoutBadCount'
Export-ModuleMember -Variable 'ResetLockoutCount'
Export-ModuleMember -Variable 'LockoutDuration'
Export-ModuleMember -Variable 'EnableGuestAccount'
