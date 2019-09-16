@echo off
setlocal
REM ############## SETUP
rem set MSYS_HOME=
set BOOST_VER=1.70.0
REM ############## SETUP END

set BOOST_NAME=boost_%BOOST_VER:.=_%

IF NOT EXIST %BOOST_NAME%.tar.bz2 (
xcopy ..\..\build\%BOOST_NAME%.tar.bz2 %CD%
)

docker build -t ubuntu-dev_valgrind_on -f Dockerfile_valgrind_on .
docker build -t ubuntu-dev_valgrind_on-console -f Dockerfile_valgrind_on.console .

endlocal