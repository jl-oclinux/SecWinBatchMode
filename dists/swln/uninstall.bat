ECHO OFF

SET regkey=SWLN

REM Clean the ProgramData folder
DEL /F /Q "%ProgramData%\SWMB\Presets\CurrentUser-Logon.preset"
DEL /F /Q "%ProgramData%\SWMB\Presets\LocalMachine-Boot.preset"
DEL /F /Q "%ProgramData%\SWMB\Presets\LocalMachine-PostInstall.preset"
DEL /F /Q "%ProgramData%\SWMB\Modules\Custom-VarOverload.psm1"
DEL /F /Q "%ProgramData%\SWMB\Modules\Local-Addon.psm1"

REM Clean the registry
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey% /f

REM Clean the SWLN folder (must be the last line - auto-remove)
IF EXIST "%ProgramFiles%\SWLN" RMDIR /S /Q "%ProgramFiles%\SWLN"
