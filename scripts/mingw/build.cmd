@echo off
SETLOCAL
rem *********BEGIN SETUP***********
rem for MSYS YOU NEED to install 'mingw-w64-x86_64-make', 'mingw-w64-x86_64-cmake' : pacman -S mingw-w64-x86_64-make mingw-w64-x86_64-cmake
rem other modules can be installed: mingw-w64-x86_64-gdb
rem msys/usr/bin isn't needed on the PATH!!!

rem set MSYS_HOME=
rem *********END SETUP***********

set PROJECT_HOME=%CD%\..\..\
set MINGW_HOME=%MSYS_HOME%\mingw64
set PATH=%PATH%;%MINGW_HOME%\bin

goto :build

IF NOT EXIST build (
rd /S /Q build
)

:build
IF NOT EXIST build (
mkdir build
)
cd build

rem --graphviz=foo
rem https://dreampuf.github.io/GraphvizOnline/
cmake -G "MinGW Makefiles" %PROJECT_HOME%\projects\cmake\ -DBUILD_TYPE=DYNAMIC -DBOOST_BUILD_INFIX=-mgw91 -DBOOST_LIB_SUFFIX=-x64-1_70

mingw32-make.exe -j8 regression-test
rem regression-test angel
rem sonia-test
rem VERBOSE=1
ENDLOCAL
