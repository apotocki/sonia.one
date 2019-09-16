REM ############## SETUP
rem set ANDROID_TARGET_PLATFORM=armv7a aarch64 i686 x86_64
rem set ANDROID_VER=16-29
REM ############## SETUP END

if "%ANDROID_TARGET_PLATFORM%" == "armv7a" (
    set ANDROID_CC=%ANDROID_TARGET_PLATFORM%-linux-androideabi%ANDROID_VER%-clang.cmd
    set ANDROID_CXX=%ANDROID_TARGET_PLATFORM%-linux-androideabi%ANDROID_VER%-clang++.cmd
    set ANDROID_HOST=arm-linux-androideabi
) else (
    set ANDROID_CC=%ANDROID_TARGET_PLATFORM%-linux-android%ANDROID_VER%-clang.cmd
    set ANDROID_CXX=%ANDROID_TARGET_PLATFORM%-linux-android%ANDROID_VER%-clang++.cmd
    set ANDROID_HOST=%ANDROID_TARGET_PLATFORM%-linux-android
)

if "%ANDROID_TARGET_PLATFORM%" == "armv7a" (
    set ANDROID_ADDRESS_MODEL=32
) else if "%ANDROID_TARGET_PLATFORM%" == "i686" (
    set ANDROID_ADDRESS_MODEL=32
) else (
    set ANDROID_ADDRESS_MODEL=64
)

if "%ANDROID_TARGET_PLATFORM%" == "armv7a" (
    set ANDROID_ARCHITECTURE=arm
) else if "%ANDROID_TARGET_PLATFORM%" == "aarch64" (
    set ANDROID_ARCHITECTURE=arm
) else (
    set ANDROID_ARCHITECTURE=x86
)



set ANDROID_AR=%ANDROID_HOST%-ar
set ANDROID_RANLIB=%ANDROID_HOST%-ranlib
