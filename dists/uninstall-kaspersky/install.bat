ECHO OFF

SET softversion=__VERSION__
SET softpatch=__PATCH__
SET softname=kasperkey Endpoint - Uninstall
SET softpublisher=RESINFO GT SWMB

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
