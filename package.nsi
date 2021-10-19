/*

# SWMB NSIS Installer
# Copyright (C) 2020-2021, CNRS, France
# License: MIT License (Same as project Win10-Initial-Setup-Script)
# Homepage: https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb
# Authors:
#  2021 - Gabriel Moreau (CNRS / LEGI)

*/

Unicode True

!include x64.nsh
!include LogicLib.nsh
!include Integration.nsh

!define NAME "SWMB"
!define VERSION "3.12.99.13"
!define DESCRIPTION "Secure Windows Mode Batch"
!define PUBLISHER "CNRS France, RESINFO / GT SWMB"
!define PUBLISHERLIGHT "CNRS France"
!define /date YEAR "%Y"
!define REGPATH_UNINSTSUBKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"
Name "${NAME}"
OutFile "${NAME}-Setup-${VERSION}.exe"
RequestExecutionLevel Admin ; Request admin rights on WinVista+ (when UAC is turned on)
InstallDir "$ProgramFiles64\${NAME}"
InstallDirRegKey HKLM "${REGPATH_UNINSTSUBKEY}" "UninstallString"
;AutoCloseWindow true ; Setup close automatically when you finish use
Icon "logo-swmb.ico" ; Select your Icon file

; Version Information 
VIAddVersionKey "ProductName" "${NAME}"
VIAddVersionKey "CompanyName" "${PUBLISHER}"
VIAddVersionKey "LegalTrademarks" "${NAME} is a name create by ${PUBLISHERLIGHT}"
VIAddVersionKey "LegalCopyright" "© 2020-${YEAR} ${PUBLISHERLIGHT}"
VIAddVersionKey "FileDescription" "${DESCRIPTION}"
VIAddVersionKey "FileVersion" "${VERSION}"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIProductVersion "${VERSION}"

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


Function .onInit
  SetShellVarContext All
  !insertmacro EnsureAdminRights

  StrCpy $InstDir "$ProgramFiles64\${NAME}"

  ${If} ${RunningX64}
  ${EnableX64FSRedirection}
  ${Else}
  MessageBox MB_OK "Sorry this application runs only on x64 machines"
  Abort
  ${EndIf}

  ReadRegStr $R0 HKLM \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" \
  "UninstallString"
  StrCmp $R0 "" done

  ${If} ${Silent}
  ClearErrors
  ExecWait '"$R0" /S_?=$INSTDIR' $0
  DetailPrint "  $R0 /S exit code $0"
  Goto done
  ${Else}
  MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
  "${NAME} is already installed. $\n$\nClick `OK` to remove the \
  previous version or `Cancel` to cancel this upgrade." \
  IDOK uninst
  Abort
  ${EndIf}

uninst:
  ClearErrors
  Exec $R0

done:

FunctionEnd

Function un.onInit
  SetShellVarContext All
  !insertmacro EnsureAdminRights
FunctionEnd


Section "Program files (Required)"
  SectionIn Ro

  SetOutPath $InstDir
  WriteUninstaller "$InstDir\Uninst.exe"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "DisplayName" "${NAME} release ${VERSION}"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "Comments" "${NAME} (${VERSION})"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "Publisher" "${PUBLISHER}"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "URLInfoAbout" "https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "DisplayIcon" "$InstDir\logo-swmb.ico"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "UninstallString" '"$InstDir\Uninst.exe"'
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "InstallFolder" "$InstDir"
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

  SetOutPath $InstDir\Setup
  File "Setup\post-install.ps1"
  File "Setup\pre-remove.ps1"

  SetOutPath $InstDir\Modules
  File "Modules\SWMB.psd1"
  File "Modules\SWMB.psm1"

  SetOutPath $InstDir\Modules\SWMB
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

  SetOutPath $InstDir\Presets
  File "Presets\CurrentUser-All.preset"
  File "Presets\CurrentUser-Logon-Test.preset"
  File "Presets\CurrentUser-Resinfo.preset"
  File "Presets\CurrentUser-UserExperience.preset"
  File "Presets\LocalMachine-All.preset"
  File "Presets\LocalMachine-Boot-Test.preset"
  File "Presets\LocalMachine-Cloud.preset"
  File "Presets\LocalMachine-CortanaSearch.preset"
  File "Presets\LocalMachine-Default.preset"
  File "Presets\LocalMachine-Service.preset"
  File "Presets\LocalMachine-Telemetry.preset"
  File "Presets\LocalMachine-UniversalApps.preset"
  File "Presets\LocalMachine-UserExperience.preset"
  File "Presets\Post-Install.preset"

  SetOutPath $InstDir\Tasks
  File "Tasks\CurrentUser-Logon.ps1"
  File "Tasks\LocalMachine-Boot.ps1"
  
  ; ProgramData and sets all user permissions
  SetShellVarContext all ; to have $AppData point to ProgramData folder
  CreateDirectory "$AppData\${NAME}\Logs"
  CreateDirectory "$AppData\${NAME}\Modules"
  CreateDirectory "$AppData\${NAME}\Presets"
  ;AccessControl::GrantOnFile "$AppData\${NAME}" "(S-1-5-32-545)" "FullAccess"
  ;AccessControl::GrantOnFile "$AppData\${NAME}\*" "(S-1-5-32-545)" "FullAccess"

  ; Capy Simple Sample Test
  SetOutPath $AppData\${NAME}\Presets
  File "Presets\CurrentUser-Logon-Test.preset"
  File "Presets\LocalMachine-Boot-Test.preset"
SectionEnd

Section "Task Scheduler"
  nsExec::ExecToStack 'powershell -InputFormat None -ExecutionPolicy Bypass -File "$InstDir\Setup\post-install.ps1"  '
  Pop $0 ; return value/error/timeout
  Pop $1 ; printed text, up to ${NSIS_MAX_STRLEN}
  DetailPrint '"$InstDir\Setup\post-install.ps1"'
  DetailPrint "  Printed: $1"
  DetailPrint "  Return value: $0"
  DetailPrint ""
SectionEnd

Section "Start Menu shortcut"
  CreateShortcut /NoWorkingDir "$SMPrograms\${NAME}.lnk" "$InstDir\swmb.ps1"
SectionEnd


Section -Uninstall
  nsExec::ExecToStack 'powershell -InputFormat None -ExecutionPolicy Bypass -File "$InstDir\Setup\pre-remove.ps1"  '
  Pop $0 ; return value/error/timeout
  Pop $1 ; printed text, up to ${NSIS_MAX_STRLEN}
  DetailPrint '"$InstDir\Setup\pre-remove.ps1"'
  DetailPrint "  Printed: $1"
  DetailPrint "  Return value: $0"
  DetailPrint ""

  ${UnpinShortcut} "$SMPrograms\${NAME}.lnk"
  Delete "$SMPrograms\${NAME}.lnk"

  SetShellVarContext all
  RMDir "$AppData\${NAME}\Logs"
  RMDir "$AppData\${NAME}\Modules"
  Delete "$AppData\${NAME}\Presets\CurrentUser-Logon-Test.preset"
  Delete "$AppData\${NAME}\Presets\LocalMachine-Boot-Test.preset"
  RMDir "$AppData\${NAME}\Presets"
  RMDir "$AppData\${NAME}"

  Delete "$InstDir\Uninst.exe"
  Delete "$InstDir\swmb.ps1"
  Delete "$InstDir\logo-swmb.ico"
  Delete "$InstDir\CONTRIBUTING.md"
  Delete "$InstDir\FAQ.md"
  Delete "$InstDir\LICENSE.md"
  Delete "$InstDir\NEWS.md"
  Delete "$InstDir\README.md"
  Delete "$InstDir\REFERENCES.md"
  RMDir /r "$InstDir\Modules"
  RMDir /r "$InstDir\Presets"
  RMDir /r "$InstDir\Tasks"
  RMDir /r "$InstDir\Setup"
  RMDir "$InstDir"
  DeleteRegKey HKLM "${REGPATH_UNINSTSUBKEY}"
SectionEnd
