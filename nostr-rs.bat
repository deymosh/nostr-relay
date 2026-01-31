@echo off
setlocal

echo ==========================================
echo   NOSTR-RS RELAY SETUP + RUN (Windows Installer)
echo ==========================================
echo.

REM --- Paths ---
set "BAT_DIR=%~dp0"
set "REPO_DIR=%BAT_DIR%nostr-rs-relay"
set "SRC_CONF=%REPO_DIR%\config.toml"
set "DST_CONF=%BAT_DIR%\config.toml"

REM --- Step 1: Init submodule if missing ---
if not exist "%REPO_DIR%" (
    echo Initializing nostr-rs-relay submodule...
    git submodule update --init --recursive
    if errorlevel 1 (
        echo Error initializing submodule
        pause
        exit /b 1
    )
) else (
    echo nostr-rs-relay submodule already exists. Updating...
    git submodule update --recursive
    if errorlevel 1 (
        echo Error updating submodule
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
echo - name: relay name
echo - description: relay description
echo - relay_icon: relay icon URL

REM --- Step 3: Run Docker Compose ---
echo.
echo ==========================================
echo   Starting NOSTR-RS RELAY with Docker Compose
echo ==========================================
echo.

cd /d "%BAT_DIR%"
docker compose -p nostr-rs -f nostr-rs-docker-compose.yml up --build
if errorlevel 1 (
    echo Error running Docker Compose
    pause
    exit /b 1
)

pause
exit /b 0
