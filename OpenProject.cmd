@echo off
setlocal enabledelayedexpansion

if exist ".\_ShotcutPortable\extracted.flag" (
    echo Opening the standalone Shotcut project...
) else (
    echo Opening the standalone Shotcut project for the first time ^(subsequent openings will be faster^)...
    
    if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
        set zipfile=shotcut-x64.zip
    ) else (
        if "%PROCESSOR_ARCHITEW6432%"=="AMD64" (
            set zipfile=shotcut-x64.zip
        ) else (
            set zipfile=shotcut-arm64.zip
        )
    )
	
    ".\_ShotcutPortable\7z\7za.exe" x ".\_ShotcutPortable\!zipfile!" -o".\_ShotcutPortable" -aoa

    if not errorlevel 1 (
        echo > ".\_ShotcutPortable\extracted.flag"
    )
)
if errorlevel 1 goto fail
start "" "_ShotcutPortable\Shotcut/shotcut.exe" "src\Project.mlt"
if errorlevel 1 (
    goto fail
) else (
    del ".\_ShotcutPortable\shotcut-x64.zip" >nul 2>&1
    del ".\_ShotcutPortable\shotcut-arm64.zip" >nul 2>&1
    rmdir /s /q .\_ShotcutPortable\7z >nul 2>&1
    goto end
)

:fail
    color 0C
    echo.
    echo An error occurred. Please ensure your standalone Shotcut project is fully present and no other processes are trying to access it.
    pause

:end
