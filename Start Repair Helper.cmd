@echo off
echo Developer fallback helper. Normal users: run Install Repair.cmd once instead - then nothing needs to stay open.
echo.
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js is missing. Install Node.js LTS from https://nodejs.org then try again.
  pause
  exit /b 1
)
if not exist "%LOCALAPPDATA%\agy\bin\agy.exe" (
  echo AGY is missing. Follow steps 2 and 3 in REPAIR-SETUP.md first.
  pause
  exit /b 1
)
node repair-helper.cjs
pause
