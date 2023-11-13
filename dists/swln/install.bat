ECHO OFF

SET softname=__SWLN_NAME__

SET logdir=%SystemRoot%\Logs\Deploy
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

ECHO Adds the rights to run powershell scripts
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO Deletes the %softname% directory
IF EXIST "%ProgramFiles%\%softname%" RMDIR /S /Q "%ProgramFiles%\%softname%"

ECHO Creation of the install directory
MKDIR "%ProgramFiles%\%softname%"

ECHO Copy post-install script
COPY /Y post-install.ps1 "%ProgramFiles%\%softname%"

ECHO Execution right post-install.ps1
%pwrsh% "Unblock-File -Path ${env:ProgramFiles}\%softname%\post-install.ps1"

ECHO Post-install (install SWMB and run it one time)
%pwrsh% -File "%ProgramFiles%\%softname%\post-install.ps1"

ECHO Change Add and Remove values in the register
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%softregkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion%-%softrevision% / %swmbversion%)"
>> tmp_install.reg ECHO "DisplayIcon"="C:\\Program Files\\%softname%\\logo-swmb.ico"
>> tmp_install.reg ECHO "InstallFolder"="C:\\Program Files\\%softname%"
>> tmp_install.reg ECHO "Publisher"="%softpublisher%"
>> tmp_install.reg ECHO "UninstallString"="C:\\Program Files\\%softname%\\uninstall.bat"
>> tmp_install.reg ECHO "NoModify"=dword:00000001
>> tmp_install.reg ECHO "NoRepair"=dword:00000001
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%

EXIT
