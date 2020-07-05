@echo off
SETLOCAL

set TPLS_HOME=%1

REM ############## SETUP
if NOT defined MSYS_HOME (
    echo MSYS_HOME is no defined
    set errorlevel=1
    goto :error
)
if NOT defined ICU_VER (
    echo ICU_VER is no defined
    set errorlevel=1
    goto :error
)
REM ############## SETUP END

set PATH=%PATH%;%MSYS_HOME%\usr\bin\

IF NOT EXIST icu4c-%ICU_VER%.zip (
echo downloading icu4c-%ICU_VER% ...
curl -L https://github.com/unicode-org/icu/releases/download/release-%ICU_VER:.=-%/icu4c-%ICU_VER:.=_%-Win64-MSVC2017.zip -o icu4c-%ICU_VER%.zip || goto :error
rem curl -L http://download.icu-project.org/files/icu4c/%ICU_VER%/icu4c-%ICU_VER:.=_%-Win64-MSVC2017.zip -o icu4c-%ICU_VER%.zip || goto :error
)

IF NOT EXIST icu4c-%ICU_VER% (
echo extracting icu4c-%ICU_VER%.zip ...
mkdir icu4c-%ICU_VER%
unzip -q icu4c-%ICU_VER%.zip -d icu4c-%ICU_VER%/
)

echo installing icu...
if exist %TPLS_HOME%\icu (
rm -rf %TPLS_HOME%\icu
)
mkdir %TPLS_HOME%\icu

cp -r icu4c-%ICU_VER%\include %TPLS_HOME%\icu\
cp -r icu4c-%ICU_VER%\lib64 %TPLS_HOME%\icu\lib
cp -r icu4c-%ICU_VER%\bin64 %TPLS_HOME%\icu\bin

goto :end

:error
echo Failed with error code #%errorlevel%.

:end

ENDLOCAL
