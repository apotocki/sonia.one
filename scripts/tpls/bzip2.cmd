@echo off
SETLOCAL

set TPLS_HOME=%1

REM ############## SETUP
rem expected system variables:
rem set MSYS_HOME=
rem set MSVS_BUILD=
set BZLIB2_VER=1.0.6
REM ############## SETUP END

set PATH=%PATH%;%MSYS_HOME%\usr\bin\

IF NOT EXIST bzip2-%BZLIB2_VER%.tgz (
echo downloading bzip2-%BZLIB2_VER% ...
curl -L https://sourceforge.net/projects/bzip2/files/bzip2-%BZLIB2_VER%.tar.gz/download -o bzip2-%BZLIB2_VER%.tgz
)

IF NOT EXIST bzip2-%BZLIB2_VER% (
echo extracting bzip2-%BZLIB2_VER%.tgz ...
tar -xf bzip2-%BZLIB2_VER%.tgz
)

echo building bzip2-%BZLIB2_VER% ...
call "%MSVS_BUILD%\vcvars64.bat"
cd bzip2-%BZLIB2_VER%
nmake -f makefile.msc clean
nmake -f makefile.msc
nmake -f makefile.msc test

echo installing bzip2-%BZLIB2_VER% ...
if exist %TPLS_HOME%\bzip2 (
rm -rf %TPLS_HOME%\bzip2
)

mkdir %TPLS_HOME%\bzip2
mkdir %TPLS_HOME%\bzip2\include
mkdir %TPLS_HOME%\bzip2\lib
cp ./{bzlib.h} %TPLS_HOME%\bzip2\include\
cp ./{libbz2.lib} %TPLS_HOME%\bzip2\lib\

sed s/-MD/-MDd/ makefile.msc > makefileD.msc
sed -i s/libbz2/libbz2d/ makefileD.msc
nmake -f makefileD.msc clean
nmake -f makefileD.msc
nmake -f makefileD.msc test
cp ./{libbz2d.lib} %TPLS_HOME%\bzip2\lib\

cd ..
ENDLOCAL
