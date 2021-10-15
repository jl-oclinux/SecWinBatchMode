/*

# SWMB NSIS Installer
# Copyright (C) 2020-2021, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb
# Authors:
#  2021 - Gabriel Moreau (CNRS / LEGI)

*/

Unicode True

!include LogicLib.nsh
!include Integration.nsh

!define NAME "SWMB"
!define SWMBVersion "3.12.99.3"
!define REGPATH_UNINSTSUBKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"
Name "${NAME}"
OutFile "${NAME}-Setup-${SWMBVersion}.exe"
RequestExecutionLevel Admin ; Request admin rights on WinVista+ (when UAC is turned on)
InstallDir "$ProgramFiles64\$(^Name)"
InstallDirRegKey HKLM "${REGPATH_UNINSTSUBKEY}" "UninstallString"

Page Directory
Page InstFiles

Uninstpage UninstConfirm
Uninstpage InstFiles

!macro EnsureAdminRights
  UserInfo::GetAccountType
  Pop $0
  ${If} $0 != "admin" ; Require admin rights on WinNT4+
    MessageBox MB_IconStop "Administrator rights required!"
    SetErrorLevel 740 ; ERROR_ELEVATION_REQUIRED
    Quit
  ${EndIf}
!macroend

!include x64.nsh

Function .onInit
  SetShellVarContext All
  !insertmacro EnsureAdminRights

  ${If} ${RunningX64}
  ${EnableX64FSRedirection}
  ${else}
  MessageBox MB_OK "Sorry this application runs only on x64 machines"
  Abort
  ${EndIf}
FunctionEnd

Function un.onInit
  SetShellVarContext All
  !insertmacro EnsureAdminRights
FunctionEnd


Section "Program files (Required)"
  SectionIn Ro

  SetOutPath $InstDir
  WriteUninstaller "$InstDir\Uninst.exe"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "DisplayName" "${NAME} release ${SWMBVersion}"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "DisplayVersion" "${SWMBVersion}"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "Comments" "${NAME} (${SWMBVersion})"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "Publisher" "CNRS RESINFO / GT SWMB"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "URLInfoAbout" "https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "DisplayIcon" "$InstDir\logo-swmb.ico"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "UninstallString" '"$InstDir\Uninst.exe"'
  WriteRegDWORD HKLM "${REGPATH_UNINSTSUBKEY}" "NoModify" 1
  WriteRegDWORD HKLM "${REGPATH_UNINSTSUBKEY}" "NoRepair" 1

  File "swmb.ps1"
  File "logo-swmb.ico"
  File "CONTRIBUTING.md"
  File "FAQ.md"
  File "LICENSE.md"
  File "NEWS.md"
  File "README.md"
  File "REFERENCES.md"

  SetOutPath $INSTDIR\Modules
  File "Modules\SWMB.psd1"
  File "Modules\SWMB.psm1"

  SetOutPath $INSTDIR\Modules\SWMB
  File "Modules\SWMB\BSI.psm1"
  File "Modules\SWMB\Contrib.psm1"
  File "Modules\SWMB\CurrentUser-Application.psm1"
  File "Modules\SWMB\CurrentUser-ExplorerUI.psm1"
  File "Modules\SWMB\CurrentUser-Privacy.psm1"
  File "Modules\SWMB\CurrentUser-Service.psm1"
  File "Modules\SWMB\CurrentUser-UI.psm1"
  File "Modules\SWMB\CurrentUser-Unpinning.psm1"
  File "Modules\SWMB\CurrentUser-UWPPrivacy.psm1"
  File "Modules\SWMB\Custom.psm1"
  File "Modules\SWMB\Custom-VarDefault.psm1"
  File "Modules\SWMB\Experimental.psm1"
  File "Modules\SWMB\Resinfo.psm1"
  File "Modules\SWMB\TemporaryBypass.psm1"
  File "Modules\SWMB\Win10-Application.psm1"
  File "Modules\SWMB\Win10-ExplorerUI.psm1"
  File "Modules\SWMB\Win10-Network.psm1"
  File "Modules\SWMB\Win10-Privacy.psm1"
  File "Modules\SWMB\Win10-Security.psm1"
  File "Modules\SWMB\Win10-Server.psm1"
  File "Modules\SWMB\Win10-Service.psm1"
  File "Modules\SWMB\Win10-UI.psm1"
  File "Modules\SWMB\Win10-UWPPrivacy.psm1"

  SetOutPath $INSTDIR\Presets
  File "Presets\CurrentUser-All.preset"
  File "Presets\CurrentUser-Resinfo.preset"
  File "Presets\CurrentUser-UserExperience.preset"
  File "Presets\LocalMachine-All.preset"
  File "Presets\LocalMachine-Cloud.preset"
  File "Presets\LocalMachine-CortanaSearch.preset"
  File "Presets\LocalMachine-Default.preset"
  File "Presets\LocalMachine-Service.preset"
  File "Presets\LocalMachine-Telemetry.preset"
  File "Presets\LocalMachine-UniversalApps.preset"
  File "Presets\LocalMachine-UserExperience.preset"
  File "Presets\Post-Install.preset"

  SetOutPath $INSTDIR\Tasks
  File "Tasks\CurrentUser-Logon.ps1"
  File "Tasks\LocalMachine-Boot.ps1"

  SetOutPath $INSTDIR\Setup
  File "Setup\post-install.ps1"
  File "Setup\pre-remove.ps1"

  nsExec::ExecToStack 'powershell -InputFormat None -ExecutionPolicy Bypass -File "$InstDir\Setup\post-install.ps1"  '
SectionEnd

Section "Start Menu shortcut"
  CreateShortcut /NoWorkingDir "$SMPrograms\${NAME}.lnk" "$InstDir\swmb.ps1"
SectionEnd


Section -Uninstall
  nsExec::ExecToStack 'powershell -InputFormat None -ExecutionPolicy Bypass -File "$InstDir\Setup\pre-remove.ps1"  '

  ${UnpinShortcut} "$SMPrograms\${NAME}.lnk"
  Delete "$SMPrograms\${NAME}.lnk"

  Delete "$InstDir\Uninst.exe"
  Delete "$InstDir\swmb.ps1"
  Delete "$InstDir\logo-swmb.ico"
  Delete "$InstDir\CONTRIBUTING.md"
  Delete "$InstDir\FAQ.md"
  Delete "$InstDir\LICENSE.md"
  Delete "$InstDir\NEWS.md"
  Delete "$InstDir\README.md"
  Delete "$InstDir\REFERENCES.md"
  RMDir /r $INSTDIR\Modules
  RMDir /r $INSTDIR\Presets
  RMDir /r $INSTDIR\Tasks
  RMDir /r $INSTDIR\Setup
  RMDir "$InstDir"
  DeleteRegKey HKLM "${REGPATH_UNINSTSUBKEY}"
SectionEnd
