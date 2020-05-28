################################################################
# Project CNRS RESINFO SWMB
# Copyright (C) 2020, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb
# Authors:
#  2020 - Olivier de Marchi (Grenoble INP / LEGI)
#  2020 - David Gras (CNRS / DR11)
#  2020 - Clément Deiber (CNRS / DR11)
#  2020 - Gabriel Moreau (CNRS / LEGI)
################################################################

# Variables utilisées dans le script Win10-My-Swmb.psm1
# Ne modifier pas directement ce fichier !
# Vous pouvez surcharger ces variables en les redéfinissant dans un fichier Win10-My-Swmb-VarOverload.psm1

$myLocalAdminNameToSet = "sas-swmb"
$myLocalAdminNameOriginal = "administrateur"
$myInactivityTimeoutSecs = 1200

Export-ModuleMember -Variable 'myLocalAdminNameToSet'
Export-ModuleMember -Variable 'myLocalAdminNameOriginal'
Export-ModuleMember -Variable 'myInactivityTimeoutSecs'
