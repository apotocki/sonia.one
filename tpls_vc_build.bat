@echo off

REM ############## SETUP
rem install msys2; pacman -Syu; pacman -S git unzip nasm mingw-w64-x86_64-perl mingw-w64-x86_64-cmake mingw-w64-x86_64-make mingw-w64-x86_64-gcc zlib-devel mingw-w64-x86_64-icu openssl-devel
rem expected system variables:
rem set MSYS_HOME=C:\Program Files\msys64
rem set MSVS_BUILD=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
REM ############## SETUP END

set TPLS_HOME=%CD%\tpls 

IF NOT EXIST build (
mkdir build
)
cd build

call ..\scripts\tpls\icu.cmd %TPLS_HOME%
call ..\scripts\tpls\icu.mingw64.cmd %TPLS_HOME%
call ..\scripts\tpls\boost.cmd %TPLS_HOME%
call ..\scripts\tpls\boost.mingw64.cmd %TPLS_HOME%
call ..\scripts\tpls\zlib.cmd %TPLS_HOME%
call ..\scripts\tpls\bzip2.cmd %TPLS_HOME%
rem call ..\scripts\tpls\lz4.cmd %TPLS_HOME%
call ..\scripts\tpls\lexertl.cmd %TPLS_HOME%
call ..\scripts\tpls\libpng.cmd %TPLS_HOME%
call ..\scripts\tpls\pixman.cmd %TPLS_HOME%
call ..\scripts\tpls\cairo.cmd %TPLS_HOME%
call ..\scripts\tpls\openssl.cmd %TPLS_HOME%

cd ..
