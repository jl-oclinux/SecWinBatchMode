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

@{
RootModule = 'SWMB.psm1'
NestedModules = @('.\SWMB\Core.psm1', '.\SWMB\Win10.psm1', '.\SWMB\Resinfo.psm1')
ModuleVersion = '3.11.1'
GUID = 'ba50acca-ccda-456b-8349-6ff2569dc229'
Author = 'RESINFO / GT SWMB'
CompanyName = 'CNRS'
Copyright = '(C) 2020-2021 CNRS, France. All rights reserved.'
Description = "
Secure Windows Mode Batch

Source for this module is at IN2P3 GitLab.  Please submit any issues there.
https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
"
}
