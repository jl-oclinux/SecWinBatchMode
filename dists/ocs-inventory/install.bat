ECHO OFF

SET softversion=__VERSION__
SET softrevision=__REVISION__
SET softname=SWMB - Configuration RESINFO
SET regkey=SWMB
SET softpublisher=RESINFO GT SWMB
SET logfile="C:\Program Files\SWMB\logfile.log"

SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

REM create folder
IF NOT EXIST "C:\Program Files\SWMB" MKDIR "C:\Program Files\SWMB"

REM log
COPY /y NUL "C:\Program Files\SWMB\logfile.log" >NUL  
ECHO %date%-%time% >> %logfile%

REM silent install
SWMB-Setup-%softversion%.exe /S

REM ajoute les droits pour l'execution de scripts powershell
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

REM droits execution sur swmb.ps1 et wisemoui.ps1
%pwrsh% "Unblock-File -Path ${env:ProgramFiles}\SWMB\swmb.ps1"
%pwrsh% "Unblock-File -Path ${env:ProgramFiles}\SWMB\wisemoui.ps1"

REM execution de swmb.ps1
REM ECHO SWMBPowershell>>%logfile% 2>&1
REM C:
REM CD "C:\Program Files\SWMB"
REM %pwrsh% -File "C:\Program Files\SWMB\swmb.ps1" -import "Modules\SWMB\Custom.psm1" -preset "Presets\LocalMachine-Default.preset" >>%logfile% 2>&1
REM execution de la tache au boot
%pwrsh% -Command "&{Start-ScheduledTask -TaskName 'SWMB-LocalMachine-Boot'}"

EXIT
