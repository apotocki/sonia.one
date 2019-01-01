@echo off
SETLOCAL

set TPLS_HOME=%1

REM ############## SETUP
rem expected system variables:
rem set MSYS_HOME=
REM ############## SETUP END

set PATH=%PATH%;%MSYS_HOME%\usr\bin\

IF NOT EXIST lexertl14 (
echo downloading lexertl14 ...
git clone https://github.com/BenHanson/lexertl14 lexertl14
)

echo installing lexertl14...
if exist %TPLS_HOME%\lexertl14 (
rd /S /Q %TPLS_HOME%\lexertl14
)

xcopy lexertl14\include %TPLS_HOME%\lexertl14\include\ /s /e /q /i

ENDLOCAL
