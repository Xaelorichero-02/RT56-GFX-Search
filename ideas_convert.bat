@echo off
setlocal enabledelayedexpansion

:: Define file paths
set "infile=%~dp0ideas.gfx"
set "outfile=%~dp0ideas_temp.gfx"

:: Clean any previous output
if exist "%outfile%" del "%outfile%"

:: Initialize variables
set "name="
set "texture="

:: Process each line
for /f "usebackq tokens=* delims=" %%A in ("%infile%") do (
    set "line=%%A"

    :: Skip comment lines
    echo !line! | findstr /b /c:"#">nul && (
        continue
    )

    :: Trim whitespace
    for /f "tokens=* delims= " %%B in ("!line!") do set "line=%%B"

    :: Get name
    echo !line! | findstr /c:"name = " >nul && (
        for /f "tokens=2 delims== " %%n in ("!line!") do set "name=%%~n"
        set "name=!name:"=!"
    )

    :: Get texturefile and write block
    echo !line! | findstr /c:"texturefile = " >nul && (
        for /f "tokens=2 delims== " %%t in ("!line!") do set "texture=%%~t"
        set "texture=!texture:"=!"

        :: Convert .dds to .png for output
        set "textureOut=!texture:.dds=.png!"

        :: Strip only the prefix GFX_idea_ from name
        set "displayName=!name:GFX_idea_=!"

        >>"%outfile%" echo     ^<div data-clipboard-text="!displayName!" data-search-text="!displayName!" title="!displayName!" class="icon"^>
        >>"%outfile%" echo         ^<img src="!textureOut!" loading="lazy" alt="!displayName!"^>
        >>"%outfile%" echo     ^</div^>
        >>"%outfile%" echo.
    )
)

:: Overwrite the original file
move /y "%outfile%" "%infile%" >nul

echo Done. Updated ideas.gfx.
pause
