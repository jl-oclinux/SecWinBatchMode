@ECHO OFF

REM --------------------------------------------------------------------------
REM
REM Ce script doit etre lance en tant qu'administrateur avec privileges
REM Il copie les scripts depuis un partage smb sur le poste local et cree
REM une tache planifiee qui execute le script au démarrage du poste
REM
REM --------------------------------------------------------------------------

REM repertoire des fichiers de script "sources"
SET srcFolder="\\MyServer\MySecuriseShare"

REM repertoire local d'installation des fichiers des scripts
SET destFolder="C:\SWMB"

REM log file name
SET logfile=logfileSWMBInstallation.txt

REM powershell executable
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe


ECHO %date%-%time% > %~dp0\%logfile%

REM ajoute temporaire des droits d'exécution
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope Process 2>&1 >> %~dp0\%logfile%

REM creation du répertoire
IF NOT EXIST %destFolder% (mkdir %destFolder%  2>&1 >> %~dp0\%logfile%)

REM copie des scripts
XCOPY  %srcFolder%\*  %destFolder%\ /E /I /Q /R /Y 2>&1 >> %~dp0\%logfile%

REM deblocage des fichiers
%pwrsh% "dir -Path %destFolder% -recurse | Unblock-File" >> %~dp0\%logfile%


REM creation de la tache planifiee
schtasks /create /tn swmbAtBoot /sc onstart /RU SYSTEM  /F /tr "powershell.exe -ExecutionPolicy RemoteSigned -file '%destFolder%\swmb.ps1' -preset '%destFolder%\Presets\UserExperience-Resinfo.preset'"  2>&1 >> %~dp0\%logfile%
