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

################################################################

# https://www.cert.ssi.gouv.fr/alerte/CERTFR-2021-ALE-013/
# CVE-2021-34527 exploit to keep your Print Servers running while a patch is not available
Function DisablePrintForSystem {
	$acl = Get-Acl -Path "$Env:SystemRoot\System32\spool\drivers"
	$ruleOrg1 = New-Object System.Security.AccessControl.FileSystemAccessRule('NT AUTHORITY\System', 'FullControl', 'ContainerInherit,ObjectInherit', 'None',        'Allow')
	$ruleOrg2 = New-Object System.Security.AccessControl.FileSystemAccessRule('NT AUTHORITY\System', 'FullControl', 'ContainerInherit,ObjectInherit', 'InheritOnly', 'Allow')
	$ruleNew1 = New-Object System.Security.AccessControl.FileSystemAccessRule('NT AUTHORITY\System', 'Modify',      'ContainerInherit,ObjectInherit', 'None',        'Deny')
	$ruleNew2 = New-Object System.Security.AccessControl.FileSystemAccessRule('NT AUTHORITY\System', 'Read',        'ContainerInherit,ObjectInherit', 'None',        'Allow')
	$acl.RemoveAccessRule($ruleOrg1)
	$acl.RemoveAccessRule($ruleOrg2)
	$acl.AddAccessRule($ruleNew1)
	$acl.AddAccessRule($ruleNew2)
	$acl | Set-Acl -Path "$Env:SystemRoot\System32\spool\drivers"
}

Function EnablePrintForSystem {
	$acl = Get-Acl -Path "$Env:SystemRoot\System32\spool\drivers"
	$ruleOrg1 = New-Object System.Security.AccessControl.FileSystemAccessRule('NT AUTHORITY\System', 'FullControl', 'ContainerInherit,ObjectInherit', 'None',        'Allow')
	$ruleOrg2 = New-Object System.Security.AccessControl.FileSystemAccessRule('NT AUTHORITY\System', 'FullControl', 'ContainerInherit,ObjectInherit', 'InheritOnly', 'Allow')
	$ruleNew1 = New-Object System.Security.AccessControl.FileSystemAccessRule('NT AUTHORITY\System', 'Modify',      'ContainerInherit,ObjectInherit', 'None',        'Deny')
	$ruleNew2 = New-Object System.Security.AccessControl.FileSystemAccessRule('NT AUTHORITY\System', 'Read',        'ContainerInherit,ObjectInherit', 'None',        'Allow')
	$acl.RemoveAccessRule($ruleNew1)
	$acl.RemoveAccessRule($ruleNew2)
	$acl.AddAccessRule($ruleOrg1)
	$acl.AddAccessRule($ruleOrg2)
	$acl | Set-Acl -Path "$Env:SystemRoot\System32\spool\drivers"
}

Function ViewPrintForSystem {
	Get-Acl -Path "$Env:SystemRoot\System32\spool\drivers" | Select -Expand Access | Out-GridView
}


################################################################
###### Export Functions
################################################################

# Export functions
Export-ModuleMember -Function *
