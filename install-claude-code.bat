@echo off
title Install Claude Code
echo ============================================
echo   Claude Code installer for Windows
echo ============================================
echo.
echo [0/2] Windows info:
powershell -NoProfile -Command "$v=[Environment]::OSVersion.Version; 'Windows build: ' + $v.Build + '   PowerShell: ' + $PSVersionTable.PSVersion + '   64-bit: ' + [Environment]::Is64BitOperatingSystem; if ($v.Build -lt 17763) { 'WARNING: Claude Code needs Windows 10 version 1809 (build 17763) or newer.' }"
echo.
echo [1/2] Checking Git for Windows...
where git >nul 2>nul
if %errorlevel%==0 (
  echo Git is already installed.
  goto claude
)
if exist "%ProgramFiles%\Git\cmd\git.exe" (
  echo Git is already installed.
  goto claude
)
echo Downloading Git for Windows from GitHub...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $r=Invoke-RestMethod -UseBasicParsing https://api.github.com/repos/git-for-windows/git/releases/latest; $a=$r.assets | Where-Object { $_.name -match '^Git-.*-64-bit\.exe$' } | Select-Object -First 1; $f=Join-Path $env:TEMP $a.name; Write-Host ('Downloading ' + $a.name + ' ...'); Invoke-WebRequest -UseBasicParsing $a.browser_download_url -OutFile $f; Write-Host 'Installing Git (please wait, click Yes if asked)...'; Start-Process $f -ArgumentList '/VERYSILENT','/NORESTART' -Wait"
if errorlevel 1 goto fail_git
echo Git installed.

:claude
echo.
echo [2/2] Installing Claude Code...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://claude.ai/install.ps1 | iex"
if errorlevel 1 goto fail_claude
echo.
echo ============================================
echo SUCCESS. Close this window, open a NEW PowerShell, then run:
echo     cd %USERPROFILE%\Desktop\mycom
echo     claude
echo ============================================
pause
exit /b 0

:fail_git
echo.
echo *** FAILED to install Git. ***
echo Please install it manually: https://git-scm.com/downloads/win
echo Then run this file again.
pause
exit /b 1

:fail_claude
echo.
echo *** FAILED to install Claude Code. ***
echo Please copy all the text in this window and send it to Claude.
pause
exit /b 1
