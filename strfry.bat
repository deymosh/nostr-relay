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
    echo Clonando repo strfry...
    git clone https://github.com/deymosh/strfry
    if errorlevel 1 (
        echo Error clonando el repo
        pause
        exit /b 1
    )
) else (
    echo Repo strfry ya existe.
)

REM --- Step 2: Copy default config if missing ---
if not exist "%DST_CONF%" (
    copy "%SRC_CONF%" "%DST_CONF%" >nul
    echo Config por defecto copiada a %DST_CONF%
    echo Puedes cambiar los valores siguientes directamente en el archivo:
    echo - pubkey: clave admin (hex)
    echo - icon: URL del icono
    echo - name: nombre del relay
    echo - description: descripcion del relay
) else (
    echo Config existente encontrada en "%DST_CONF%"
    echo Puedes cambiar los valores siguientes directamente en el archivo:
    echo - pubkey: clave admin (hex)
    echo - icon: URL del icono
    echo - name: nombre del relay
    echo - description: descripcion del relay
)

REM --- Step 3: Run Docker Compose ---
echo.
echo ==========================================
echo   Arrancando STRFRY con Docker Compose
echo ==========================================
echo.

cd /d "%BAT_DIR%"
docker compose -p strfry -f strfry-docker-compose.yml up --build
if errorlevel 1 (
    echo Error ejecutando Docker Compose
    pause
    exit /b 1
)

pause
exit /b 0
