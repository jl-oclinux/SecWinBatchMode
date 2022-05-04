ECHO OFF

SET softversion=1.0
SET softpatch=1
SET softname=kasperkey Endpoint - Uninstall
SET regkey=SWMB
SET softpublisher=RESINFO GT SWMB
SET logfile="C:\Program Files\SWMB\logfile.txt"

SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe


REM add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

REM unblock
%pwrsh% "Unblock-File -Path .\*.ps1"
%pwrsh% "Unblock-File -Path .\*.psm1"

REM execute
%pwrsh% -File ".\uninstall-kaspersky.ps1"

EXIT
