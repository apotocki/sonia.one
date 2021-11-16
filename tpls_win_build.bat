@echo off
setlocal
REM ############## SETUP
rem install msys2; pacman -Syu; pacman -S git unzip nasm mingw-w64-x86_64-perl mingw-w64-x86_64-cmake mingw-w64-x86_64-make mingw-w64-x86_64-gcc zlib-devel mingw-w64-x86_64-icu openssl-devel python3 make
rem expected system variables:
rem set MSYS_HOME=C:\Program Files\msys64
rem set MSVS_BUILD=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
rem set MSBUILD_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin"
REM ############## SETUP END

set WIN_KIT_VERSION=10.0.18362.0
set WIN_TOOLSET_NAME=msvc-14.2

set SCRIPT_HOME=%CD%
set TPLS_HOME=%CD%\tpls 

set PATH=%CD%\scripts\tpls\workaround;%PATH%

IF NOT EXIST build (
mkdir build
)
pushd build

call ..\scripts\tpls\openssl.cmd %TPLS_HOME%
call ..\scripts\tpls\icu\%ICU_VER%\icu.cmd %TPLS_HOME%
call ..\scripts\tpls\icu.mingw64.cmd %TPLS_HOME%

call ..\scripts\tpls\boost\%BOOST_VER%\boost.cmd %TPLS_HOME% %SCRIPT_HOME%
rem call ..\scripts\tpls\boost\%BOOST_VER%\boost.cmd %TPLS_HOME% %SCRIPT_HOME% VC
rem call ..\scripts\tpls\boost\%BOOST_VER%\boost.cmd %TPLS_HOME% %SCRIPT_HOME% MINGW

call ..\scripts\tpls\zlib.cmd %TPLS_HOME%
call ..\scripts\tpls\bzip2.cmd %TPLS_HOME%
rem call ..\scripts\tpls\lz4.cmd %TPLS_HOME%
call ..\scripts\tpls\lexertl.cmd %TPLS_HOME%
call ..\scripts\tpls\libpng.cmd %TPLS_HOME%
call ..\scripts\tpls\pixman.cmd %TPLS_HOME%
call ..\scripts\tpls\cairo.cmd %TPLS_HOME%

popd
endlocal
