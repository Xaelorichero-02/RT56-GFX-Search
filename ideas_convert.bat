@echo off
setlocal enabledelayedexpansion

:: Set input and temp output paths
set "infile=%~dp0ideas.gfx"
set "outfile=%~dp0ideas_temp.gfx"

:: Delete temp file if exists
if exist "%outfile%" del "%outfile%"

:: Initialize variables
set "name="
set "texture="

for /f "usebackq tokens=* delims=" %%A in ("%infile%") do (
    set "line=%%A"

    :: Skip comment lines
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

        :: Remove .dds from texture path
        set "textureNoExt=!texture:.dds=!"

        :: Strip 'GFX_idea_' prefix from name for display
        set "displayName=!name:GFX_idea_=!"

        >>"%outfile%" echo     ^<div data-clipboard-text="!displayName!" data-search-text="!displayName!" title="!displayName!" class="icon"^>
        >>"%outfile%" echo         ^<img src="!textureNoExt!.png" loading="lazy" alt="!displayName!"^>
        >>"%outfile%" echo     ^</div^>
        >>"%outfile%" echo.
    )
)

:: Replace the original file with the new content
move /y "%outfile%" "%infile%" >nul

echo Conversion complete. Updated ideas.gfx.
pause
