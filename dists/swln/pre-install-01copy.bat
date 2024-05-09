ECHO Adds the rights to run powershell scripts
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO Deletes the %softname% directory
IF EXIST "%ProgramFiles%\%softname%" RMDIR /S /Q "%ProgramFiles%\%softname%"

ECHO Creation of the install directory
MKDIR "%ProgramFiles%\%softname%"

ECHO Copy installer script
COPY /Y installer.ps1 "%ProgramFiles%\%softname%"

ECHO Execution right installer.ps1
%pwrsh% "Unblock-File -Path ${Env:ProgramFiles}\%softname%\installer.ps1"
