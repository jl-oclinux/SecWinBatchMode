ECHO OFF

SET softname=SWLN

SET logdir=%SystemRoot%\Logs\Deploy
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=4.6
SET softpatch=2
SET softregkey=SWLN
SET softpublisher=RESINFO / Local Network Area
SET swmbversion=3.6

SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Adds the rights to run powershell scripts
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO Deletes the SWLN directory
IF EXIST "%ProgramFiles%\SWLN" RMDIR /S /Q "%ProgramFiles%\SWLN"

ECHO Creation of the directory
MKDIR "%ProgramFiles%\SWLN"

ECHO Copy post-install script
COPY /Y post-install.ps1 "%ProgramFiles%\SWLN"

ECHO Execution right post-install.ps1
%pwrsh% "Unblock-File -Path ${env:ProgramFiles}\SWLN\post-install.ps1"

ECHO Post-install (install SWMB and run it one time)
%pwrsh% -File "%ProgramFiles%\SWLN\post-install.ps1"

ECHO Change Add and Remove values in the register
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%softregkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion%-%softpatch% / %swmbversion%)"
>> tmp_install.reg ECHO "DisplayIcon"="C:\\Program Files\\SWLN\\logo-swmb.ico"
>> tmp_install.reg ECHO "InstallFolder"="C:\\Program Files\\SWLN"
>> tmp_install.reg ECHO "Publisher"="%softpublisher%"
>> tmp_install.reg ECHO "UninstallString"="C:\\Program Files\\SWLN\\uninstall.bat"
>> tmp_install.reg ECHO "NoModify"=dword:00000001
>> tmp_install.reg ECHO "NoRepair"=dword:00000001
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%

EXIT
