@echo off
cd /d "%~dp0"
node "native-host\install.cjs" --uninstall
echo.
pause
