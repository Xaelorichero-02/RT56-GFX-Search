@echo off
setlocal enabledelayedexpansion

set "htmlFile=index.html"
set "sectionStart=<div id=""goalsSection"" class=""docs-section"">"
set "headerTag=<h6 class=""docs-header"">"
set "entryTag=<div data-clipboard-text="

set "insideSection=false"
set "currentCategory="
set /a entryCount=0

rem Use a temp file to convert to Unix line endings (for consistent parsing)
powershell -Command "(Get-Content '%htmlFile%') | Out-File -Encoding ASCII tmp_index.html"

for /f "usebackq delims=" %%A in ("tmp_index.html") do (
    set "line=%%A"

    rem Detect start of goalsSection
    echo !line! | findstr /C:"%sectionStart%" >nul
    if !errorlevel! == 0 (
        set "insideSection=true"
        set "currentCategory="
        set /a entryCount=0
    )

    if "!insideSection!" == "true" (
        rem Detect category header
        echo !line! | findstr /C:"%headerTag%" >nul
        if !errorlevel! == 0 (
            rem If this is a new category and not the first, print previous count
            if not "!currentCategory!"=="" (
                echo !currentCategory!: !entryCount!
            )
            for /f "tokens=1,* delims=>" %%x in ("!line!") do (
                for /f "tokens=1 delims=<" %%y in ("%%x") do (
                    rem Extract category name (e.g. National focuses (2275))
                    set "currentCategory=%%x"
                    set /a entryCount=0
                )
            )
        )

        rem Count icon entries
        echo !line! | findstr /C:"class=""icon""" >nul
        if !errorlevel! == 0 (
            set /a entryCount+=1
        )
    )
)

rem Output last category count
if not "!currentCategory!"=="" (
    echo !currentCategory!: !entryCount!
)

del tmp_index.html
endlocal
pause
