@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
pushd "%SCRIPT_DIR%" >nul 2>&1
if errorlevel 1 (
    echo Unable to open the cosmic-starship directory: %SCRIPT_DIR% 1>&2
    exit /b 1
)

where git >nul 2>&1
if errorlevel 1 (
    echo Git is required to update cosmic-starship. 1>&2
    goto :fail
)

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo This copy is not a Git checkout. Clone the repository to receive updates: 1>&2
    echo   git clone https://github.com/t3m3d/cosmic-starship.git 1>&2
    goto :fail
)

for /f "delims=" %%L in ('git status --porcelain') do (
    echo Local changes found in %SCRIPT_DIR%; update stopped to preserve them. 1>&2
    echo Commit, stash, or discard those changes, then run update.bat again. 1>&2
    goto :fail
)

set "BRANCH="
for /f "delims=" %%B in ('git symbolic-ref --quiet --short HEAD 2^>nul') do set "BRANCH=%%B"
if not defined BRANCH (
    echo The repository is in detached-HEAD state; switch to main before updating. 1>&2
    goto :fail
)

echo Updating cosmic-starship on %BRANCH%...
git pull --ff-only
if errorlevel 1 goto :fail

if not exist "%SCRIPT_DIR%install.ps1" (
    echo Updated repository does not contain install.ps1. 1>&2
    goto :fail
)

echo Applying the latest prompt...
where pwsh >nul 2>&1
if not errorlevel 1 (
    pwsh -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%install.ps1"
    set "RESULT=!ERRORLEVEL!"
    goto :done
)

where powershell >nul 2>&1
if errorlevel 1 (
    echo PowerShell is required to apply the updated prompt. 1>&2
    goto :fail
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%install.ps1"
set "RESULT=%ERRORLEVEL%"
goto :done

:fail
set "RESULT=1"

:done
popd
exit /b !RESULT!
