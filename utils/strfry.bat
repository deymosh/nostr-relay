@echo off
setlocal enabledelayedexpansion

echo.
echo ==========================================
echo    STRFRY SETUP + RUN ^(Windows^)
echo ==========================================
echo.

REM Get to project root
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PROJECT_DIR=%%~fI"
set "REPO_DIR=%PROJECT_DIR%\strfry"
set "SRC_CONF=%REPO_DIR%\strfry.conf"
set "DST_CONF=%PROJECT_DIR%\strfry.conf"

REM Step 1: Clone repo if missing
if not exist "%REPO_DIR%" (
    echo Cloning strfry repo...
    cd /d "%PROJECT_DIR%"
    git clone https://github.com/hoytech/strfry
    if errorlevel 1 (
        echo Error cloning repo
        exit /b 1
    )
) else (
    echo strfry repo already exists. Updating...
    cd /d "%REPO_DIR%"
    git pull
    if errorlevel 1 (
        echo Error updating repo
        exit /b 1
    )
)

REM Step 2: Copy default config if missing
if not exist "%DST_CONF%" (
    copy "%SRC_CONF%" "%DST_CONF%"
    echo Default config copied to %DST_CONF%
) else (
    echo Existing config found at "%DST_CONF%"
)

echo You can edit the following values directly in the file:
echo - pubkey: admin pubkey (hex format)
echo - name: relay name
echo - description: relay description
echo - icon: relay icon URL

REM Step 3: Run Docker Compose
echo.
echo ==========================================
echo    Starting STRFRY with Docker
echo ==========================================
echo.

cd /d "%PROJECT_DIR%"
docker compose -p strfry -f docker/strfry-docker-compose.yml up -d --build

if errorlevel 1 (
    echo Error running Docker Compose
    exit /b 1
)

REM Wait for Tor and get onion address
echo.
echo Waiting for Tor to generate .onion address...
timeout /t 10

for /f "delims=" %%i in ('docker exec strfry-tor cat /var/lib/tor/hidden_service/hostname 2^>nul') do set "ONION_ADDR=%%i"

if defined ONION_ADDR (
    echo.
    echo ==========================================
    echo   ^! Strfry Relay is running!
    echo ==========================================
    echo.
    echo Web Interface:
    echo   Local:  http://localhost
    echo   HTTPS:  https://localhost
    echo.
    echo Tor Hidden Service (.onion):
    echo   http://!ONION_ADDR!
    echo.
    echo Nostr Relay WebSocket (default):
    echo   ws://localhost:7777
    echo   wss://localhost/ws (via reverse proxy)
    echo.
    echo Note: Edit docker/Caddyfile to add custom domain
    echo and set TOR_ENABLED=true for full Tor setup
    echo ==========================================
) else (
    echo.
    echo Warning: Could not retrieve Tor onion address.
    echo Check if Tor container is running: docker ps
    echo View logs: docker logs strfry-tor
)

exit /b 0
