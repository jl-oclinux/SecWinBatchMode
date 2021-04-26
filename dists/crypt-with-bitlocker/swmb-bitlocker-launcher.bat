@echo off
SET mypath=%~dp0
echo %mypath:~0,-1%
%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File %mypath%\swmb-bitlocker-launcher.ps1