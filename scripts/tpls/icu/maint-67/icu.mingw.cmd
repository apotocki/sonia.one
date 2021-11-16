@echo off
SETLOCAL

REM ############## SETUP
set ICU_VER=maint/maint-67
if NOT defined MSYS_HOME (
    echo MSYS_HOME is no defined
    set errorlevel=1
    goto :error
)
if NOT defined MSBUILD_PATH (
    echo MSBUILD_PATH is no defined
    set errorlevel=1
    goto :error
)
REM ############## SETUP END

set TPLS_HOME=%~1

if "%~2"=="static" (
    set ICU_BUILD_FOLDER=icu4c-%ICU_VER:/=-%-mingw-static-build
    set ConfigureOptions="--enable-static --disable-shared"
    set INSTALL_DIR="%TPLS_HOME%\icu.mingw64.static"
) else (
    set ICU_BUILD_FOLDER=icu4c-%ICU_VER:/=-%-mingw-build
    set ConfigureOptions=""
    set INSTALL_DIR="%TPLS_HOME%\icu.mingw64"
)
rem echo %INSTALL_DIR%
rem echo %ConfigureOptions%
rem goto :end


set KEY_NAME="HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots"
set VALUE_NAME=KitsRoot10

FOR /F "usebackq tokens=1,2,*" %%A IN (`REG QUERY %KEY_NAME% /v %VALUE_NAME% 2^>nul`) DO (
    set WIN_KIT_ROOT=%%C
)
set WIN_KIT_INCLUDE=%WIN_KIT_ROOT%Include\%WIN_KIT_VERSION%\ucrt
set WIN_KIT_LIB=%WIN_KIT_ROOT%Lib\%WIN_KIT_VERSION%\ucrt\x64
echo %WIN_KIT_INCLUDE%

set PATH=%MSYS_HOME%\mingw64\bin;%MSYS_HOME%\usr\bin;%PATH%

IF NOT EXIST icu4c-%ICU_VER:/=-% (
echo downloading icu4c-%ICU_VER:/=-% ...
git clone https://github.com/unicode-org/icu -b %ICU_VER% icu4c-%ICU_VER:/=-%
) else (
echo updating icu4c-%ICU_VER:/=-% ...
cd icu4c-%ICU_VER:/=-%
git pull
cd ..
)

set ICU_SRC_FOLDER=icu4c-%ICU_VER:/=-%\icu4c

echo preparing build folder %ICU_BUILD_FOLDER% ...

rem cd %ICU_BUILD_FOLDER%
rem goto :patch

IF EXIST %ICU_BUILD_FOLDER% (
    rm -rf %ICU_BUILD_FOLDER%
)
xcopy icu4c-%ICU_VER:/=-%\icu4c %ICU_BUILD_FOLDER% /s /e /q /i


echo building icu...
pushd %ICU_BUILD_FOLDER%\source

rem must be run only in source forlder else bugs... (e.g. not really resolved ICU-20315)
bash runConfigureICU MinGW %ConfigureOptions% prefix=%INSTALL_DIR:\=/% CXXFLAGS="--std=c++17" || goto :error
cp config/mh-mingw64 config/mh-unknown

:build
make.exe -j8 || goto :error

echo installing icu...
if exist %INSTALL_DIR% (
rm -rf %INSTALL_DIR%
)
make.exe install || goto :error

popd

:patch
rem echo patch install folders icu...
rem move /Y %INSTALL_DIR%\lib %INSTALL_DIR%\lib64
rem move /Y %INSTALL_DIR%\bin %INSTALL_DIR%\bin64

echo Done.
goto :end

:error
echo Failed with error code #%errorlevel%.

:end

ENDLOCAL
