SETLOCAL
echo off
rem *********SETUP***********
rem for MSYS YOU NEED to install 'mingw-w64-x86_64-make' : pacman -S mingw-w64-x86_64-make
rem other modules can be installed: mingw-w64-x86_64-gdb
rem msys/usr/bin isn't needed on the PATH!!!
rem set PROJECT_NAME=potocki-dev-temp2
rem set CMAKE_HOME=c:\Developments\cmake-2.8.12.2
set CMAKE_HOME=c:\Developments\cmake-3.6.2
set PROJECT_HOME=k:\projects\wayout\sonia-dev\sonia-master
set MSYS_HOME=c:\Developments\msys64

set MINGW_HOME=%MSYS_HOME%\mingw64

set BOOST_INCLUDE=C:\Developments\boost_1_68_0
set BOOST_LIB=%BOOST_INCLUDE%\stage\lib.mingw.820.cxx17
set BOOST_LIB_SUFFIX=x64-1_68
set BOOST_BUILD_INFIX=mgw82
rem set JAVA_HOME=c:\Developments\jdk1.8\
rem set ICU_HOME=c:\Developments\icu4c-56.1
rem set CPLUS_INCLUDE_PATH=C:\jrockit-jdk1.6.0_22-R28.1.1-4.0.1\include;C:\jrockit-jdk1.6.0_22-R28.1.1-4.0.1\include\win32
rem set LIBRARY_PATH=C:\jrockit-jdk1.6.0_22-R28.1.1-4.0.1\lib
rem ********END SETUP********

set PATH=%PATH%;%MINGW_HOME%\bin
IF EXIST build (
rem rd /S /Q build
)
mkdir build
cd build

rem --graphviz=foo
rem https://dreampuf.github.io/GraphvizOnline/

%CMAKE_HOME%\bin\cmake.exe -G "MinGW Makefiles" %PROJECT_HOME%\projects\cmake\ -DCMAKE_TOOLCHAIN_FILE=%PROJECT_HOME%\projects\cmake\mingw.toolchain.cmake -DBUILD_TYPE=DYNAMIC

mingw32-make.exe -j4 sonia-test
rem ontoquad
rem margot-db margot-core component_tests ontonode margot-java
rem VERBOSE=1
ENDLOCAL

