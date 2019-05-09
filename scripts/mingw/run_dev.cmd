@echo off
SETLOCAL
rem *********BEGIN SETUP***********
rem set MSYS_HOME=
rem *********END SETUP***********

set SONIA_HOME=%CD%\..\..
set SONIA_PRIME_HOME=%SONIA_HOME%\bundles\sonia-prime
set BUILD=%CD%\build
set MINGW_HOME=%MSYS_HOME%\mingw64
PATH=%PATH%;%SONIA_HOME%\tpls\boost\lib;%SONIA_HOME%\tpls\icu.mingw64\lib;%MINGW_HOME%\bin;%BUILD%\sonia-prime

cd %SONIA_HOME%\workdirs\tests\
%BUILD%\dev-test\dev-test.exe --no_color_output --log_level=test_suite
ENDLOCAL
