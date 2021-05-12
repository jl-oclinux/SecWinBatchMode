Function DisableBitlocker {

    $listVolume = Get-volume | Where-Object { $_.DriveType -eq "Fixed" }
    foreach ($volume in $listVolume) {
        if (-not ($volume.DriveLetter)) { continue }
        $letter = $volume.DriveLetter
        Disable-BitLocker $letter
    }

}
