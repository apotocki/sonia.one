@echo off
SETLOCAL

set TPLS_HOME=%1
REM ############## SETUP
rem expected system variables:
rem set MSYS_HOME=
rem set MSVS_BUILD=
set LZ4_VER=v1.8.3
REM ############## SETUP END

set PATH=%PATH%;%MSYS_HOME%\usr\bin\

if not exist lz4%LZ4_VER% (
echo downloading lz4%LZ4_VER% ...
git clone https://github.com/lz4/lz4 lz4%LZ4_VER%
cd lz4%LZ4_VER%
git checkout tags/%LZ4_VER% -b %LZ4_VER%
) else (
echo updating lz4%LZ4_VER% ...
cd lz4%LZ4_VER%
git pull tags/%LZ4_VER%
cd ..
)

goto :end
echo building lz4%LZ4_VER% ...
call "%MSVS_BUILD%\vcvars64.bat"
cd lz4%LZ4_VER%
sed s/-MD/-MT/ scripts\makefile.vcwin32 > scripts\makefile.vcwin32.fixed
nmake -f scripts\makefile.vcwin32.fixed

echo installing lz4%LZ4_VER% ...
if exist %TPLS_HOME%\lz4 (
rm -rf %TPLS_HOME%\lz4
)
mkdir %TPLS_HOME%\lz4
mkdir %TPLS_HOME%\lz4\include
mkdir %TPLS_HOME%\lz4\lib
cp ./{png.h,pnglibconf.h,pngconf.h} %TPLS_HOME%\libpng\include\
cp ./libpng.lib %TPLS_HOME%\libpng\lib\

:end
ENDLOCAL
