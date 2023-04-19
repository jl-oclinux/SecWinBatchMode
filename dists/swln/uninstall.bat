ECHO OFF

SET regkey=SWLN

REM Cleean ProgramData
DEL /F /Q "%ProgramData%\SWMB\Presets\CurrentUser-Logon.preset"
DEL /F /Q "%ProgramData%\SWMB\Presets\LocalMachine-Boot.preset"
DEL /F /Q "%ProgramData%\SWMB\Modules\Custom-VarOverload.psm1"

REM Clean registry
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey% /f

REM Clean the SWLN folder
IF EXIST "%ProgramFiles%\SWLN" RMDIR /S /Q "%ProgramFiles%\SWLN"
