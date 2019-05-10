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
nmake -f win32/Makefile.msc AS=ml64 CFLAGS="-nologo -MD -W3 -O2 -Oy- -Zi -Fd\"zlib\"" zlib.lib zlib1.dll zdll.lib test
rem LOC="-DASMV -DASMINF -I." OBJA="inffasx64.obj gvmat64.obj inffas8664.obj" 

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
cp ./{zlib.lib,zdll.lib,zdll.exp,zlib.pdb} %TPLS_HOME%\zlib\lib\

echo building debug version
nmake -f win32/Makefile.msc clean

nmake -f win32/Makefile.msc AS=ml64 STATICLIB="zlibd.lib" SHAREDLIB="zlib1d.dll" IMPLIB="zdlld.lib" CFLAGS="-nologo -MDd -W3 -O2 -Oy- -Zi -Fd\"zlibd\"" zlibd.lib zlib1d.dll zdlld.lib test
rem LOC="-DASMV -DASMINF -I." OBJA="inffasx64.obj gvmat64.obj inffas8664.obj" 
cp ./{zlib1d.dll,zlib1d.pdb} %TPLS_HOME%\zlib\bin\
cp ./{zlibd.lib,zdlld.lib,zdlld.exp} %TPLS_HOME%\zlib\lib\

cd ..
ENDLOCAL
