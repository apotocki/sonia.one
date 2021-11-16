@echo off
SETLOCAL

set TPLS_HOME=%1
set BUILD_HOME=%CD%
REM ############## SETUP
if NOT defined MSYS_HOME (
    echo MSYS_HOME is no defined
    set errorlevel=1
    goto :error
)
if NOT defined ANDROID_NDK_ROOT (
    echo ANDROID_NDK_ROOT is not defined
    set errorlevel=1
    goto :error
)
if NOT defined ICU_VER (
    echo ICU_VER is no defined
    set errorlevel=1
    goto :error
)

if "%ANDROID_TARGET_PLATFORM%" == "armv7a" (
    set CFG_CFLAGS=-march=armv7-a -mfloat-abi=softfp -mfpu=neon
    set CFG_LDFLAGS=-march=armv7-a -Wl,--fix-cortex-a8
) else if "%ANDROID_TARGET_PLATFORM%" == "i686" (
    set CFG_CFLAGS=-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32
    set CFG_LDFLAGS=
) else if "%ANDROID_TARGET_PLATFORM%" == "x86_64" (
    set CFG_CFLAGS=-march=x86-64
    set CFG_LDFLAGS=
) else if "%ANDROID_TARGET_PLATFORM%" == "aarch64" (
    set CFG_CFLAGS=
    set CFG_LDFLAGS=
) else (
    echo "ANDROID_TARGET_PLATFORM is unknown (%ANDROID_TARGET_PLATFORM%)"
    set errorlevel=1
    goto :error
)
REM ############## SETUP END

rem we need cross build environment
if NOT EXIST %BUILD_HOME%\icu.mingw64.build (
    CALL %BUILD_HOME%\..\scripts\tpls\icu.mingw64.cmd
)

set PATH=%PATH%;%MSYS_HOME%\usr\bin;%MSYS_HOME%\mingw64\bin
rem set PATH=%PATH%;%ANDROID_NDK_ROOT%\toolchains\llvm\prebuilt\windows\arm-linux-androideabi\bin
set PATH=%PATH%;%ANDROID_NDK_ROOT%\toolchains\llvm\prebuilt\windows\bin
set PATH=%PATH%;%BUILD_HOME%\..\tpls\icu.mingw64\lib

CALL %BUILD_HOME%\..\scripts\tpls\util\android.cmd

echo building icu...

IF EXIST icu.android.%ANDROID_TARGET_PLATFORM%.build (
rm -rf icu.android.%ANDROID_TARGET_PLATFORM%.build
)
mkdir icu.android.%ANDROID_TARGET_PLATFORM%.build

cd icu.android.%ANDROID_TARGET_PLATFORM%.build

bash ../icu4c-%ICU_VER%-src/source/configure --prefix=%TPLS_HOME:\=/%/icu.android.%ANDROID_TARGET_PLATFORM% ^
    --host=%ANDROID_HOST% ^
    -with-cross-build=%BUILD_HOME:\=/%/icu.mingw64.build  ^
    CFLAGS='-Os %CFG_FLAGS%' ^
    CXXFLAGS='--std=c++17 %CFG_FLAGS%' ^
    LDFLAGS='%CFG_LDFLAGS%' ^
    CC=%ANDROID_CC% ^
    CXX=%ANDROID_CXX% ^
    AR=%ANDROID_AR% ^
    RINLIB=%ANDROID_RANLIB% ^
    --with-data-packaging=archive
    
mingw32-make.exe -j4 || goto :error

echo installing icu...
mingw32-make.exe install || goto :error

cd ..

goto :end

:error
echo Failed with error code #%errorlevel%.

:end

ENDLOCAL
