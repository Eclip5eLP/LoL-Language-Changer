@echo off
title League of Legends Language Changer

set appDir=%cd%
set dataDir="%appdata%\..\Local\PenumbraGames\"
if not exist %dataDir% mkdir %dataDir%
set dataDir="%appdata%\..\Local\PenumbraGames\LoL_Language_Changer\"
if not exist %dataDir% mkdir %dataDir%

if not exist "%dataDir%\loldir.dat" goto setup
cd "%dataDir%"
ren loldir.dat loldir.bat
call loldir.bat
ren loldir.bat loldir.dat
cd "%appDir%"

set lolExe="%lolDir%\LeagueClient.exe"

:menu
cls
echo 1. English
echo 2. Japanese
echo 3. Korean
echo 4. German
echo 5. Spanish
echo 6. Italian
echo 7. French
echo 8. Russian
echo C. Custom
set /p c=Please choose your desired language: 

set locale=NONE
if %c% equ 1 set locale=en_GB
if %c% equ 2 set locale=ja_JP
if %c% equ 3 set locale=ko_KR
if %c% equ 4 set locale=de_DE
if %c% equ 5 set locale=es_ES
if %c% equ 6 set locale=it_IT
if %c% equ 7 set locale=fr_FR
if %c% equ 8 set locale=ru_RU
if %c% equ C goto customLang
if "%locale%" equ "NONE" goto menu

:setLocale
set langShort=%locale:~3,2%
set shortName="%userprofile%\Desktop\League of Legends %langShort%.lnk"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%shortName%');$s.TargetPath='%lolExe%';$s.Arguments='--locale=%locale%';$s.Save()"
call :log "Language changed to '%langShort%' (%locale%)"

echo.
echo Language changed!
echo Please use the newly created Shortcut on your Desktop to start League
pause > nul
exit

:setup
set riotDefault=C:\Riot Games\League of Legends
cls
echo League Client Language Changer Setup
echo.
echo Detecting League installation...
if exist "%riotDefault%" goto setup_default
echo League not found!
set /p c=Enter League Directory (Default: "%riotDefault%"): 
cd "%dataDir%"
(
echo @echo off
echo set lolDir=%c%
)>loldir.dat
cd "%appDir%"
call :log "League path set to '%c%'"
start "" %0
exit

:customLang
echo.
echo Make sure you know how to set the language properties.
echo.
set /p locale=Enter Language Code: 
call :strLen locale strlen
if %strlen% equ 5 goto setLocale
echo Invalid Language Code!
pause > nul
goto menu

:setup_default
cd "%dataDir%"
(
echo @echo off
echo set lolDir=%riotDefault%
)>loldir.dat
cd "%appDir%"
call :log "League path set to '%riotDefault%'"
start "" %0
exit

:strLen
setlocal enabledelayedexpansion
:strLen_Loop
   if not "!%1:~%len%!"=="" set /A len+=1 & goto :strLen_Loop
(endlocal & set %2=%len%)
goto eof

:log
set lastDir=%cd%
if "%~1" equ "" goto eof
cd "%dataDir%"
echo [%date%_%time%] %~1 >> log.txt
cd "%appDir%"
echo [%date%_%time%] %~1 >> log.txt
cd "%lastDir%"
goto eof

:eof