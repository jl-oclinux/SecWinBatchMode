ECHO OFF

SET softname=__SWLN_NAME__
SET softregkey=%softname%

ECHO Clean the ProgramData folder
DEL /F /Q "%ProgramData%\SWMB\Presets\CurrentUser-Logon.preset"
DEL /F /Q "%ProgramData%\SWMB\Presets\LocalMachine-Boot.preset"
DEL /F /Q "%ProgramData%\SWMB\Presets\LocalMachine-PostInstall.preset"
DEL /F /Q "%ProgramData%\SWMB\Modules\Custom-VarOverload.psm1"
DEL /F /Q "%ProgramData%\SWMB\Modules\Local-Addon.psm1"

ECHO Clean the registry
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%softregkey% /f

ECHO Clean the %softname% installation folder (must be the last line - auto-remove)
IF EXIST "%ProgramFiles%\%softname%" RMDIR /S /Q "%ProgramFiles%\%softname%"
