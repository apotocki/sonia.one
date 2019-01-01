@echo off
SETLOCAL

set TPLS_HOME=%1
REM ############## SETUP
rem expected system variables:
rem set MSYS_HOME=
rem set MSVS_BUILD=
set LIBPNG_VER=16
REM ############## SETUP END

set PATH=%PATH%;%MSYS_HOME%\usr\bin\

if not exist libpng%LIBPNG_VER% (
echo downloading libpng%LIBPNG_VER% ...
git clone https://github.com/glennrp/libpng -b libpng%LIBPNG_VER% libpng%LIBPNG_VER%
) else (
echo updating libpng%LIBPNG_VER% ...
cd libpng%LIBPNG_VER%
git pull
cd ..
)

echo building libpng%LIBPNG_VER% ...
call "%MSVS_BUILD%\vcvars64.bat"
cd libpng%LIBPNG_VER%
cp %TPLS_HOME%\zlib\include\{zlib.h,zconf.h} .\
sed s/-MD/-MT/ scripts\makefile.vcwin32 > scripts\makefile.vcwin32.fixed
nmake -f scripts\makefile.vcwin32.fixed

echo installing libpng%LIBPNG_VER% ...
if exist %TPLS_HOME%\libpng (
rm -rf %TPLS_HOME%\libpng
)
mkdir %TPLS_HOME%\libpng
mkdir %TPLS_HOME%\libpng\include
mkdir %TPLS_HOME%\libpng\lib
cp ./{png.h,pnglibconf.h,pngconf.h} %TPLS_HOME%\libpng\include\
cp ./libpng.lib %TPLS_HOME%\libpng\lib\

ENDLOCAL
