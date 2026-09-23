@echo off
title Install Claude Code
echo ============================================
echo   Claude Code installer for Windows
echo ============================================
echo.
echo [1/2] Checking Git for Windows...
where git >nul 2>nul
if %errorlevel%==0 (
  echo Git is already installed.
) else (
  echo Installing Git for Windows with winget...
  winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
)
echo.
echo [2/2] Installing Claude Code...
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://claude.ai/install.ps1 | iex"
echo.
echo ============================================
echo Done. Close this window, open a NEW PowerShell, then run:
echo     cd %USERPROFILE%\Desktop\mycom
echo     claude
echo ============================================
pause
