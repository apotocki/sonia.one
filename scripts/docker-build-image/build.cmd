@echo off
setlocal
REM ############## SETUP
rem set MSYS_HOME=
set BOOST_VER=1.74.0
REM ############## SETUP END

set BOOST_NAME=boost_%BOOST_VER:.=_%

IF NOT EXIST %BOOST_NAME%.tar.bz2 (
xcopy ..\..\build\%BOOST_NAME%.tar.bz2 %CD%
)

docker build -t ubuntu-dev -f Dockerfile .
docker build -t ubuntu-dev-console -f Dockerfile.console .

endlocal