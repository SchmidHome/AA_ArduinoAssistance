@echo off
for /f "tokens=1,2,3 delims=." %%a in ("%1") do (
   set array[1]=%%a
   set array[2]=%%b
   set array[3]=%%c
)

if not exist library.json goto :EOF
del "%TEMP%\library.json" 2>nul
set "version=%array[1]%.%array[2]%.%array[3]%"

set "substring=version"

setlocal EnableDelayedExpansion
set found=0;
for /F "tokens=1* delims=:" %%A in (library.json) do (
    set string=%%A
    set res=F
    if not "!string:%substring%=!"=="!string!" set res=T
    if !found! equ 1 set res=F
    if "!res!"=="T"  (
        set found=1
        echo FOUND %%A
        echo %%A: "%version%",>>"%TEMP%\library.json"
    ) else if "%%B" == "" (
        echo %%A>>"%TEMP%\library.json"
    ) else (
        echo NF %%A
        echo %%A:%%B>>"%TEMP%\library.json"
    )
)
move /Y "%TEMP%\library.json" library.json >nul
set "version="

git tag --force  %array[1]%.%array[2]%.%array[3]% master
git tag --force  %array[1]%.%array[2]% master
git tag --force  %array[1]% master
git push --force --tags
