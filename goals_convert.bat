@echo off
setlocal enabledelayedexpansion

:: Create a temporary file to hold the converted output
set "outfile=%~dp0goals_temp.gfx"
set "infile=%~dp0goals.gfx"

:: Delete temp file if it exists
if exist "%outfile%" del "%outfile%"

:: Initialize variables
set "name="
set "texture="

for /f "usebackq tokens=* delims=" %%A in ("%infile%") do (
    set "line=%%A"

    :: Skip comments
    echo !line! | findstr /b /c:"#">nul && (
        continue
    )

    :: Trim whitespace
    for /f "tokens=* delims= " %%B in ("!line!") do set "line=%%B"

    :: Extract name
    echo !line! | findstr /c:"name = " >nul && (
        for /f "tokens=2 delims== " %%n in ("!line!") do set "name=%%~n"
        set "name=!name:"=!"
    )

    :: Extract texturefile
    echo !line! | findstr /c:"texturefile = " >nul && (
        for /f "tokens=2 delims== " %%t in ("!line!") do set "texture=%%~t"
        set "texture=!texture:"=!"

        :: Remove file extension from texture
        set "textureNoExt=!texture:.dds=!"

        >>"%outfile%" echo     ^<div data-clipboard-text="!name!" data-search-text="!name!" title="!name!" class="icon"^>
        >>"%outfile%" echo         ^<img src="!textureNoExt!.png" loading="lazy" alt="!name!"^>
        >>"%outfile%" echo     ^</div^>
        >>"%outfile%" echo.
    )
)

:: Replace original file
move /y "%outfile%" "%infile%" >nul

echo Conversion complete. Updated goals.gfx.
pause
