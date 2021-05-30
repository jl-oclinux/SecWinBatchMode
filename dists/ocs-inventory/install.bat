ECHO OFF

SET softversion=1.0
SET softpatch=1
SET softname=SWMB - Configuration RESINFO
SET regkey=SWMB
SET softpublisher=RESINFO GT SWMB
SET logfile="C:\Program Files\SWMB\logfile.txt"

SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

COPY /y NUL "C:\Program Files\SWMB\logfile.txt" >NUL  
ECHO %date%-%time%>>%logfile%


REM ajoute les droits pour l'execution de scripts powershell
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine


REM creation du répertoire
IF NOT EXIST "C:\Program Files\SWMB" MKDIR "C:\Program Files\SWMB"
IF NOT EXIST "C:\Program Files\SWMB\Presets" MKDIR "C:\Program Files\SWMB\Presets"
IF NOT EXIST "C:\Program Files\SWMB\Modules" MKDIR "C:\Program Files\SWMB\Modules"
IF NOT EXIST "C:\Program Files\SWMB\Modules\SWMB" MKDIR "C:\Program Files\SWMB\Modules\SWMB"

REM copie des scripts
COPY /Y Presets\*.preset "C:\Program Files\SWMB\Presets"
COPY /Y Modules\*.psm1 "C:\Program Files\SWMB\Modules"
COPY /Y Modules\SWMB\*.psm1 "C:\Program Files\SWMB\Modules\SWMB"
COPY /Y Win10.ps1 "C:\Program Files\SWMB"

REM droits execution sur Win10.ps1
%pwrsh% "Unblock-File -Path ${env:ProgramFiles}\SWMB\Win10.ps1"

REM execeution de Win10.ps1
ECHO SWMBPowershell>>%logfile% 2>&1
C:
CD "C:\Program Files\SWMB"
%pwrsh% -File "C:\Program Files\SWMB\Win10.ps1" -include "Modules\SWMB\Custom.psm1" -preset "Preset\Cloud-Resinfo.preset" -preset "Preset\CortanaSearch-Resinfo.preset" -preset "Preset\My.preset" -preset "Preset\Telemetry-Resinfo.preset" -preset "Preset\UniversalApps-Resinfo.preset" -preset "Preset\UserExperience-Resinfo.preset" ">>%logfile% 2>&1

EXIT
