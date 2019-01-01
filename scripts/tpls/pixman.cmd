@echo off
SETLOCAL

set TPLS_HOME=%1
REM ############## SETUP
rem expected system variables:
rem set MSYS_HOME=
rem set MSVS_BUILD=
set PIXMAN_VER=0.34
REM ############## SETUP END

set PATH=%PATH%;%MSYS_HOME%\usr\bin\

if not exist pixman-%PIXMAN_VER% (
echo downloading pixman-%PIXMAN_VER% ...
git clone git://anongit.freedesktop.org/git/pixman.git -b %PIXMAN_VER% pixman-%PIXMAN_VER%
) else (
echo updating pixman-%PIXMAN_VER% ...
cd pixman-%PIXMAN_VER%
git pull
cd ..
)

echo building pixman-%PIXMAN_VER% ...
call "%MSVS_BUILD%\vcvars64.bat"
cd pixman-%PIXMAN_VER%
sed s/-MD/-MT/ Makefile.win32 > Makefile.fixed
move /Y Makefile.fixed Makefile.win32
sed s/-MD/-MT/ Makefile.win32.common > Makefile.win32.common.fixed
move /Y Makefile.win32.common.fixed Makefile.win32.common
sed 's/@PIXMAN_VERSION_MAJOR@/0/;s/@PIXMAN_VERSION_MINOR@/34/;s/@PIXMAN_VERSION_MICRO@/1/' pixman/pixman-version.h.in > pixman/pixman-version.h
rem ATTENTION using "MMX=off" to compile cairo with 64bit
make -f Makefile.win32 "MMX=off" "CFG=release"
cd ..

echo installing pixman-%PIXMAN_VER% ...
if exist %TPLS_HOME%\pixman (
rm -rf %TPLS_HOME%\pixman
)
mkdir %TPLS_HOME%\pixman
mkdir %TPLS_HOME%\pixman\include
mkdir %TPLS_HOME%\pixman\lib\pixman\release
cp pixman-%PIXMAN_VER%/pixman/{pixman.h,pixman-version.h} %TPLS_HOME%\pixman\include\
cp pixman-%PIXMAN_VER%/pixman/release/pixman-1.lib %TPLS_HOME%\pixman\lib\pixman\release

ENDLOCAL
