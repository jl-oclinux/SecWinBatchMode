ECHO OFF

SET softversion=1.0
SET softpatch=1
SET softname=SWMB - Configuration RESINFO
SET regkey=SWMB
SET softpublisher=RESINFO GT SWMB
SET logfile="C:\Program Files\SWMB\logfile.txt"

SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

REM create folder
IF NOT EXIST "C:\Program Files\SWMB" MKDIR "C:\Program Files\SWMB"

REM log
COPY /y NUL "C:\Program Files\SWMB\logfile.txt" >NUL  
ECHO %date%-%time%>>%logfile%

REM silent install
SWMB-Setup-%softversion%.exe /S

REM ajoute les droits pour l'execution de scripts powershell
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

REM droits execution sur swmb.ps1
%pwrsh% "Unblock-File -Path ${env:ProgramFiles}\SWMB\swmb.ps1"

REM execeution de swmb.ps1
ECHO SWMBPowershell>>%logfile% 2>&1
C:
CD "C:\Program Files\SWMB"
%pwrsh% -File "C:\Program Files\SWMB\swmb.ps1" -import "Modules\SWMB\Custom.psm1" -preset "Presets\LocalMachine-Default.preset" >>%logfile% 2>&1

EXIT
