@echo off
setlocal enabledelayedexpansion

:: Set working directory to script location
cd /d "%~dp0"

echo Converting .dds and .tga files to .png (including subfolders)...

:: Loop through .dds files recursively
for /R %%F in (*.dds) do (
    echo Converting "%%F"...
    magick "%%F" "%%~dpnF.png"
    if exist "%%~dpnF.png" del "%%F"
)

:: Loop through .tga files recursively
for /R %%F in (*.tga) do (
    echo Converting "%%F"...
    magick "%%F" "%%~dpnF.png"
    if exist "%%~dpnF.png" del "%%F"
)

echo Done.
pause
