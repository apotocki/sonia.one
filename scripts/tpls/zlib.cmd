@echo off
SETLOCAL

set TPLS_HOME=%1

REM ############## SETUP
rem expected system variables:
rem set MSYS_HOME=
rem set MSVS_BUILD=
set ZLIB_VER=1.2.11
REM ############## SETUP END

set PATH=%PATH%;%MSYS_HOME%\usr\bin\

IF NOT EXIST zlib-%ZLIB_VER%.tgz (
echo downloading zlib-%ZLIB_VER% ...
curl -L https://zlib.net/zlib-%ZLIB_VER%.tar.gz -o zlib-%ZLIB_VER%.tgz
)

IF NOT EXIST zlib-%ZLIB_VER% (
echo extracting zlib-%ZLIB_VER%.tgz ...
tar -xzf zlib-%ZLIB_VER%.tgz
)

echo building zlib-%ZLIB_VER% ...
call "%MSVS_BUILD%\vcvars64.bat"
cd zlib-%ZLIB_VER%
rem patching makefile
sed -i s/-base:0x5A4C0000// win32\Makefile.msc
sed -i s/-coff// win32\Makefile.msc
nmake -f win32/Makefile.msc clean
nmake -f win32/Makefile.msc AS=ml64 LOC="-DASMV -DASMINF -I." OBJA="inffasx64.obj gvmat64.obj inffas8664.obj" zlib.lib zlib1.dll zdll.lib test

echo installing zlib-%ZLIB_VER% ...
if exist %TPLS_HOME%\zlib (
rm -rf %TPLS_HOME%\zlib
)

mkdir %TPLS_HOME%\zlib
mkdir %TPLS_HOME%\zlib\include
mkdir %TPLS_HOME%\zlib\bin
mkdir %TPLS_HOME%\zlib\lib
cp ./{zlib.h,zconf.h} %TPLS_HOME%\zlib\include\
cp ./{zlib1.dll,zlib1.pdb} %TPLS_HOME%\zlib\bin\
cp ./{zlib.lib,zdll.lib,zdll.exp} %TPLS_HOME%\zlib\lib\

echo building debug version
nmake -f win32/Makefile.msc clean

sed s/-MD/-MDd/ win32\Makefile.msc > win32\MakefileD.msc
nmake -f win32/MakefileD.msc AS=ml64 STATICLIB="zlibd.lib" SHAREDLIB="zlib1d.dll" IMPLIB="zdlld.lib" LOC="-DASMV -DASMINF -I." OBJA="inffasx64.obj gvmat64.obj inffas8664.obj" zlibd.lib zlib1d.dll zdlld.lib test
cp ./{zlib1d.dll,zlib1d.pdb} %TPLS_HOME%\zlib\bin\
cp ./{zlibd.lib,zdlld.lib,zdlld.exp} %TPLS_HOME%\zlib\lib\

cd ..
ENDLOCAL
