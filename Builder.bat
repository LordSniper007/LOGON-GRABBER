@echo off
setlocal enabledelayedexpansion
cd /d %~dp0

REM === Colors ===
color 0C
echo --------------------------------------------------
echo        LOGON Builder by Discord: kixo_oio
echo --------------------------------------------------
echo.
echo WARNING! You are about to install and run this program.
echo I am NOT responsible for any consequences of using this software.
echo You do this at your OWN RISK!
echo --------------------------------------------------
echo.
echo Do you REALLY want to continue with the installation? Y - YES / N - NO
set /p FIRSTCHOICE=Your choice: 
if /i "%FIRSTCHOICE%" NEQ "Y" (
    color 0C
    echo Installation cancelled.
    echo Goodbye user, have a great day!
    call :COUNTDOWN
    exit
)

color 0A
title Checking Python installation...

python --version > nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo Python is not installed!
    echo Please download and install the latest version from:
    echo https://www.python.org/downloads
    echo Make sure Python is added to PATH.
    goto ERROR
)

color 0B
title Checking required libraries...

set LIBS=customtkinter pyinstaller setuptools urllib3 pillow wheel tinyaes pyaesm packaging pyaes

set COUNT=1
set ERRORFOUND=0
for %%L in (%LIBS%) do (
    echo Checking %%L (%COUNT%/9)
    python -c "try: import %%L; print('OK'); except: print('NOT FOUND')" > check.tmp
    set /p CHECK=<check.tmp
    del check.tmp
    
    if "!CHECK!"=="NOT FOUND" (
        color 0E
        echo Installing %%L...
        python -m pip install %%L
        if !errorlevel! neq 0 (
            color 0C
            echo.
            echo ERROR: Failed to install %%L!
            echo Please check the error message above.
            echo Press any key to exit...
            pause >nul
            set ERRORFOUND=1
            goto ENDINSTALL
        )
        color 0B
    )
    set /a COUNT+=1
)

:ENDINSTALL
if "!ERRORFOUND!"=="0" (
    call :SHORTCOUNTDOWN
)

cls
color 0C
echo --------------------------------------------------
echo        LOGON Builder by Discord: kixo_oio
echo --------------------------------------------------
echo Are you SURE you want to run the builder? Y - YES / N - NO
echo You do this at your OWN RISK!
echo.
set /p CHOICE=Your choice: 
if /i "%CHOICE%"=="Y" (
    color 0A
    title Running builder...
    python gui.py
    if %errorlevel% neq 0 goto ERROR
    exit
) else (
    color 0C
    echo --------------------------------------------------
    echo        LOGON Builder by Discord: kixo_oio
    echo --------------------------------------------------
    echo Builder launch cancelled.
    echo Goodbye user, have a great day!
    call :COUNTDOWN
    exit
)

:COUNTDOWN
setlocal enabledelayedexpansion
set BAR=
set SECONDS=5
for /l %%i in (%SECONDS%,-1,0) do (
    set BAR=!BAR!#
    cls
    color 0C
    echo Goodbye user, have a great day!
    echo.
    echo Closing in %%i seconds...
    echo [!BAR!]
    timeout /t 1 > nul
)
endlocal
goto :eof

:SHORTCOUNTDOWN
setlocal enabledelayedexpansion
set BAR=
set SECONDS=5
for /l %%i in (%SECONDS%,-1,1) do (
    set BAR=!BAR!#
    cls
    color 0A
    echo Installation finished successfully!
    echo.        "BETA VERSION"
    echo Continuing in %%i seconds...
    echo [!BAR!]
    timeout /t 1 > nul
)
endlocal
goto :eof

:ERROR
color 4F
title [Error]
pause