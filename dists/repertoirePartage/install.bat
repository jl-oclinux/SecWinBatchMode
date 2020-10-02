@ECHO OFF

REM --------------------------------------------------------------------------
REM
REM Ce script doit etre lance en tant qu'administrateur avec privileges
REM Il copie les scripts depuis un partage smb sur le poste local et cree
REM une tache planifiee qui execute le script au démarrage du poste
REM
REM --------------------------------------------------------------------------

SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe

REM Repertoire des fichiers de script "sources"
SET repSource="\\Monserver\MonPartageSecurise"

REM Repertoire local des fichiers de script
SET swmbDirectory="C:\SWMB"

SET logfile=logfileInstllation.txt


ECHO %date%-%time% > %~dp0\%logfile%

REM ajoute temporaire des droits d'exécution
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope Process 2>&1 >> %~dp0\%logfile%

REM creation du répertoire
IF NOT EXIST %swmbDirectory% (mkdir %swmbDirectory%  2>&1 >> %~dp0\%logfile%)

REM copie des scripts
XCOPY  %repSource%\*  %swmbDirectory%\ /E /I /Q /R /Y 2>&1 >> %~dp0\%logfile%

REM déblocage des fichiers
%pwrsh% "dir -Path %swmbDirectory% -recurse | Unblock-File" >> %~dp0\%logfile%


REM creation de la tache planifiee
schtasks /create /tn swmbAtBoot /sc onstart /RU SYSTEM  /F /tr "powershell.exe -ExecutionPolicy RemoteSigned -file '%swmbDirectory%\Win10-Initial-Setup-Script\Win10.ps1' -include '%swmbDirectory%\Win10-Initial-Setup-Script\Win10.psm1' -include '%swmbDirectory%\Win10-Resinfo-Swmb.psm1' -preset '%swmbDirectory%\Presets\UserExperience-Resinfo.preset'"  2>&1 >> %~dp0\%logfile%
