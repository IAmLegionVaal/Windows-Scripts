@echo off
:: ============================================================
:: Windows Troubleshooter Launcher
:: Double-click this file to run the PowerShell toolkit
:: ============================================================

:: Request Administrator elevation
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting Administrator access...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%~dp0"

:: Run the PowerShell script with bypass - window stays open
powershell.exe -NoExit -ExecutionPolicy Bypass -File "%~dp0WindowsTroubleshooter.ps1"

pause
