@echo off
SETLOCAL

set TPLS_HOME=%1
REM ############## SETUP
rem expected system variables:
rem set MSYS_HOME=
rem set MSVS_BUILD=
set CAIRO_VER=1.16
REM ############## SETUP END

set PATH=%PATH%;%MSYS_HOME%\usr\bin\

if not exist cairo-%CAIRO_VER% (
echo downloading cairo-%CAIRO_VER% ...
git clone git://anongit.freedesktop.org/git/cairo -b %CAIRO_VER% cairo-%CAIRO_VER%
) else (
echo updating cairo-%CAIRO_VER% ...
cd cairo-%CAIRO_VER%
git pull
cd ..
)

echo building cairo-%CAIRO_VER% ...
call "%MSVS_BUILD%\vcvars64.bat"
cd cairo-%CAIRO_VER%
sed s/-MD/-MT/ build\Makefile.win32.common > build\Makefile.fixed
move /Y build\Makefile.fixed build\Makefile.win32.common
sed s/zdll.lib/zlib.lib/ build\Makefile.win32.common > build\Makefile.fixed
move /Y build\Makefile.fixed build\Makefile.win32.common
set INCLUDE=%INCLUDE%;%TPLS_HOME%\zlib\include;%TPLS_HOME%\libpng\include;%TPLS_HOME%\pixman\include;
set LIB=%LIB%;%TPLS_HOME%\zlib\lib
set ZLIB_PATH=%TPLS_HOME%\zlib\lib
set LIBPNG_PATH=%TPLS_HOME%\libpng\lib
set PIXMAN_PATH=%TPLS_HOME%\pixman\lib
make -f Makefile.win32 "CFG=release"
cd..

echo installing cairo-%CAIRO_VER% ...
if exist %TPLS_HOME%\cairo (
rm -rf %TPLS_HOME%\cairo
)
mkdir %TPLS_HOME%\cairo
mkdir %TPLS_HOME%\cairo\bin
mkdir %TPLS_HOME%\cairo\include
mkdir %TPLS_HOME%\cairo\lib
cp cairo-%CAIRO_VER%/cairo-version.h %TPLS_HOME%\cairo\include\
cp cairo-%CAIRO_VER%/src/{cairo-features.h,cairo.h,cairo-deprecated.h,cairo-win32.h,cairo-script.h,cairo-ps.h,cairo-pdf.h,cairo-svg.h} %TPLS_HOME%\cairo\include\
cp cairo-%CAIRO_VER%/src/release/cairo.dll %TPLS_HOME%\cairo\bin\
cp cairo-%CAIRO_VER%/src/release/{cairo-static.lib,cairo.lib,cairo.exp} %TPLS_HOME%\cairo\lib\

ENDLOCAL
