@echo off
SETLOCAL

set TPLS_HOME=%1

REM ############## SETUP
set ICU_VER=62.1
rem set MSYS_HOME=
REM ############## SETUP END

set PATH=%PATH%;%MSYS_HOME%\usr\bin;%MSYS_HOME%\mingw64\bin

IF NOT EXIST icu4c-%ICU_VER%-src.tgz (
echo downloading icu4c-%ICU_VER% ...
curl -L http://download.icu-project.org/files/icu4c/%ICU_VER%/icu4c-%ICU_VER:.=_%-src.tgz -o icu4c-%ICU_VER%-src.tgz || goto :error
)

IF EXIST icu (
rm -rf icu
)

IF NOT EXIST icu4c-%ICU_VER%-src (
echo extracting icu4c-%ICU_VER%-src.tgz ...
tar -xf icu4c-%ICU_VER%-src.tgz || goto :error
mv icu icu4c-%ICU_VER%-src
)

echo building icu...

IF EXIST icu.mingw64.build (
rm -rf icu.mingw64.build
)
mkdir icu.mingw64.build

cd icu.mingw64.build

set CC=x86_64-w64-mingw32-gcc
set CXX=x86_64-w64-mingw32-g++
bash ../icu4c-%ICU_VER%-src/source/runConfigureICU MinGW prefix=%TPLS_HOME:\=/%/icu.mingw64
cp ../icu4c-%ICU_VER%-src/source/config/mh-mingw64 ../icu4c-%ICU_VER%-src/source/config/mh-unknown
mingw32-make.exe -j4 || goto :error

echo installing icu...
mingw32-make.exe install || goto :error

cd ..

goto :end

:error
echo Failed with error code #%errorlevel%.

:end

ENDLOCAL
