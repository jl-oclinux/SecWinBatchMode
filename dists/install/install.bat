@ECHO OFF

REM --------------------------------------------------------------------------
REM
REM This script must be run as an administrator with privileges.
REM It copies all SWMB files to the local computer's application installation
REM folder and creates a scheduled task that runs the script when the
REM computer starts.
REM
REM --------------------------------------------------------------------------

REM powershell executable
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe

%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File .\install.ps1
