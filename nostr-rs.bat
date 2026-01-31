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
    echo Inicializando submodulo nostr-rs-relay...
    git submodule update --init --recursive
    if errorlevel 1 (
        echo Error inicializando submodulo
        pause
        exit /b 1
    )
) else (
    echo Repo nostr-rs-relay ya existe.
)

REM --- Step 2: Copy default config if missing ---
if not exist "%DST_CONF%" (
    copy "%SRC_CONF%" "%DST_CONF%" >nul
    echo Config por defecto copiada a %DST_CONF%
    echo Puedes cambiar los valores siguientes directamente en el archivo:
    echo - pubkey: clave admin (hex)
    echo - name: nombre del relay
    echo - description: descripcion del relay
    echo - relay_icon: URL del icono
) else (
    echo Config existente encontrada en "%DST_CONF%"
    echo Puedes cambiar los valores siguientes directamente en el archivo:
    echo - pubkey: clave admin (hex)
    echo - name: nombre del relay
    echo - description: descripcion del relay
    echo - relay_icon: URL del icono
)

REM --- Step 3: Run Docker Compose ---
echo.
echo ==========================================
echo   Arrancando NOSTR-RS RELAY con Docker Compose
echo ==========================================
echo.

cd /d "%BAT_DIR%"
docker compose -p nostr-rs -f nostr-rs-docker-compose.yml up --build
if errorlevel 1 (
    echo Error ejecutando Docker Compose
    pause
    exit /b 1
)

pause
exit /b 0
