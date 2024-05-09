ECHO OFF

SET softname=__SWLN_NAME__

SET logdir=__LOG_DIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__SWLN_VERSION__
SET softrevision=__REVISION__
SET softregkey=%softname%
SET softpublisher=__PUBLISHER__
SET swmbversion=__SWMB_VERSION__

SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe


ECHO Call pre-installation scripts
FOR %%s IN (pre-install-*.bat) DO CALL "%%s"


ECHO Installer (install SWMB and run it one time)
%pwrsh% -File "%ProgramFiles%\%softname%\installer.ps1"


ECHO Call post-installation scripts
FOR %%s IN (post-install-*.bat) DO CALL "%%s"


ECHO END %date%-%time%

EXIT
