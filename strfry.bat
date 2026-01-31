@echo off
setlocal

echo ==========================================
echo   STRFRY SETUP + RUN (Windows Installer)
echo ==========================================
echo.

REM --- Paths ---
set "BAT_DIR=%~dp0"
set "REPO_DIR=%BAT_DIR%strfry"
set "SRC_CONF=%REPO_DIR%\strfry.conf"
set "DST_CONF=%BAT_DIR%strfry.conf"

REM --- Step 1: Clone repo if missing ---
if not exist "%REPO_DIR%" (
    echo Cloning strfry repo...
    git clone https://github.com/deymosh/strfry
    if errorlevel 1 (
        echo Error cloning repo
        pause
        exit /b 1
    )
) else (
    echo strfry repo already exists. Updating...
    cd /d "%REPO_DIR%"
    git pull
    if errorlevel 1 (
        echo Error updating repo
        pause
        exit /b 1
    )
)

REM --- Step 2: Copy default config if missing ---
if not exist "%DST_CONF%" (
    copy "%SRC_CONF%" "%DST_CONF%" >nul
    echo Default config copied to %DST_CONF%
) else (
    echo Existing config found at "%DST_CONF%"
)
echo You can edit the following values directly in the file:
echo - pubkey: admin pubkey (hex format)
echo - icon: relay icon URL
echo - name: relay name
echo - description: relay description

REM --- Step 3: Run Docker Compose ---
echo.
echo ==========================================
echo   Starting STRFRY with Docker Compose
echo ==========================================
echo.

cd /d "%BAT_DIR%"
docker compose -p strfry -f strfry-docker-compose.yml up --build
if errorlevel 1 (
    echo Error running Docker Compose
    pause
    exit /b 1
)

pause
exit /b 0
