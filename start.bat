@echo off

cd /d %~dp0

echo =========================
echo   Survey Tool Starting
echo =========================

:: Check Node.js
node -v >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Node.js not found!
    echo Installing Node.js...

    powershell -Command ^
    "Invoke-WebRequest https://nodejs.org/dist/v18.20.2/node-v18.20.2-x64.msi -OutFile node.msi"

    echo Installing Node...
    start /wait msiexec /i node.msi /quiet /norestart

    del node.msi

    echo Node installed successfully!
)

:: Check again
node -v >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to install Node.js
    pause
    exit
)

:: Check node_modules
if not exist node_modules (
    echo Installing dependencies...
    npm install
)

:: Ensure Playwright uses local browsers
set PLAYWRIGHT_BROWSERS_PATH=0

:: Check Playwright browser
if not exist node_modules\playwright-core\.local-browsers (
    echo Installing Playwright browser...
    npx playwright install chromium
)

echo Starting Survey Tool...

node main.js

pause