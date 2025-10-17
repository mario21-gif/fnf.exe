@echo off
chcp 65001 >nul
title Lancement PsychEngine + vidéo + fond d'écran
color 0A

:: Répertoire du script
set "SCRIPT_DIR=%~dp0"
set "GAME_FOLDER=%SCRIPT_DIR%MesFichiers\lol caca"
set "EXE_NAME=PsychEngine.exe"
set "VIDEO_PATH=%SCRIPT_DIR%MesFichiers\file2.mp4"
set "WALLPAPER_URL=https://i.postimg.cc/3RpL8BWG/t-l-chargement.png"
set "WALLPAPER_PATH=%TEMP%\wallpaper.jpg"

:: Affichage des chemins utilisés pour vérifier
echo ===== TEST DES CHEMINS =====
echo Chemin du script : %SCRIPT_DIR%
echo Chemin jeu : %GAME_FOLDER%\%EXE_NAME%
echo Chemin vidéo : %VIDEO_PATH%
echo ===========================
pause

:: [1] Lancer la vidéo
echo [1] Lancement de la vidéo...
if exist "%VIDEO_PATH%" (
    echo ✔ Vidéo trouvée : %VIDEO_PATH%
    start "" "%VIDEO_PATH%"
) else (
    echo ❌ ERREUR : Vidéo introuvable à : %VIDEO_PATH%
)
timeout /t 1 >nul

:: Compte à rebours 15 secondes avant lancement du jeu
echo [2] Attente de 15 secondes avant lancement du jeu...
for /L %%i in (15,-1,1) do (
    <nul set /p=⌛ %%i secondes restantes...     
    timeout /t 1 >nul
    echo.
)

:: [3] Lancer le jeu
echo [3] Lancement de PsychEngine...
if exist "%GAME_FOLDER%\%EXE_NAME%" (
    pushd "%GAME_FOLDER%"
    start "" "%EXE_NAME%"
    popd
    echo ✔ Jeu lancé.
) else (
    echo ❌ ERREUR : Jeu introuvable à : %GAME_FOLDER%\%EXE_NAME%
)
timeout /t 2 >nul

:: [4] Télécharger le fond d'écran
echo [4] Téléchargement du fond d'écran...
powershell -Command "Invoke-WebRequest -Uri '%WALLPAPER_URL%' -OutFile '%WALLPAPER_PATH%'"

:: [5] Appliquer le fond d'écran
echo [5] Application du fond d'écran...
powershell -Command ^
"Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value '%WALLPAPER_PATH%'; ^
Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class Wallpaper { [DllImport(\"user32.dll\")] public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); }'; ^
[Wallpaper]::SystemParametersInfo(20, 0, '%WALLPAPER_PATH%', 3)"

:: [6] Synthèse vocale
echo [6] Lecture vocale...
echo Set S = CreateObject("SAPI.SpVoice") > "%TEMP%\voice.vbs"
echo S.Speak "Tous les programmes sont lancés. Bon courage." >> "%TEMP%\voice.vbs"
cscript //nologo "%TEMP%\voice.vbs"
del "%TEMP%\voice.vbs"

echo.
echo [✔] Script terminé.
pause
