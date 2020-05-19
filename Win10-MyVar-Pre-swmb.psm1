#Variables utilisees dans le script Win10-My-Swmb.psm1
$myLocalAdminNameToSet = "sas-swmb"
$myLocalAdminNameOriginal = "administrateur"
$myInactivityTimeoutSecs = 1200

Export-ModuleMember -Variable 'myLocalAdminNameToSet'
Export-ModuleMember -Variable 'myLocalAdminNameOriginal'
Export-ModuleMember -Variable 'myInactivityTimeoutSecs'