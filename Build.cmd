@echo off
setlocal enabledelayedexpansion

set "shotcut64URL=https://github.com/mltframework/shotcut/releases/download/v24.11.17/shotcut-win64-241117.zip"
set "shotcut64File=.\_ShotcutPortable\shotcut-x64.zip"
set "shotcut64Hash=08d4f76cfa79a76edd7cd0f965d8da94cc873fba"

set "shotcutARMURL=https://github.com/mltframework/shotcut/releases/download/v24.11.17/shotcut-win_ARM-241117.zip"
set "shotcutARMFile=.\_ShotcutPortable\shotcut-arm64.zip"
set "shotcutARMHash=e508af28d7e2629a3f73f335a916e80684c6e76b"

set "archive7zURL=https://github.com/ip7z/7zip/releases/download/24.08/7z2408-extra.7z"
set "archive7zFile=.\_ShotcutPortable\7z.7z"
set "archive7zHash=1490fafec812e59818e838c94f7777380501db84"

if not exist ".\_ShotcutPortable" (
	mkdir ".\_ShotcutPortable"
	attrib +h ".\_ShotcutPortable"
)

if not exist "%shotcut64File%" (
    curl -L "%shotcut64URL%" -o "%shotcut64File%"
) else (
    certutil -hashfile "%shotcut64File%" SHA1 | findstr /c:"%shotcut64Hash%" >nul || curl -L "%shotcut64URL%" -o "%shotcut64File%"
)

if not exist "%shotcutARMFile%" (
    curl -L "%shotcutARMURL%" -o "%shotcutARMFile%"
) else (
    certutil -hashfile "%shotcutARMFile%" SHA1 | findstr /c:"%shotcutARMHash%" >nul || curl -L "%shotcutARMURL%" -o "%shotcutARMFile%"
)

if not exist ".\_ShotcutPortable\7z\extracted_%archive7zHash%.flag" (
	if exist "%archive7zFile%" (
		certutil -hashfile "%archive7zFile%" SHA1 | findstr /c:"%archive7zHash%" >nul || curl -L "%archive7zURL%" -o "%archive7zFile%"
	) else (
		curl -L "%archive7zURL%" -o "%archive7zFile%"
	)
	if exist ".\_ShotcutPortable\7z" (
		del /S /Q ".\_ShotcutPortable\7z\*" >nul 2>&1
	) else (
		mkdir .\_ShotcutPortable\7z
	)
	tar -xf "%archive7zFile%" -C .\_ShotcutPortable\7z
	if not errorlevel 1 (
		for /f "tokens=* skip=1 delims= " %%a in ('certutil -hashfile "%archive7zFile%" SHA1') do (
			set "actual7zHash=%%a"
			goto :hashdone
		)
		:hashdone
		echo > ".\_ShotcutPortable\7z\extracted_!actual7zHash!.flag"
		del ".\_ShotcutPortable\7z.7z" >nul 2>&1
	)
)

attrib +h ".\OpenProject.ps1"
.\_ShotcutPortable\7z\7za.exe a StandaloneProject .\src .\OpenProject.ps1 .\OpenProject .\_ShotcutPortable
.\_ShotcutPortable\7z\7za.exe rn StandaloneProject.7z OpenProject OpenProject.lnk

endlocal
