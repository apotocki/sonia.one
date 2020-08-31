@echo off
SETLOCAL ENABLEEXTENSIONS

set TPLS_HOME=%1

REM ############## SETUP
if NOT defined MSYS_HOME (
    echo MSYS_HOME is no defined
    set errorlevel=1
    goto :end
)
if NOT defined ANDROID_NDK_ROOT (
    echo ANDROID_NDK_ROOT is no defined
    set errorlevel=1
    goto :end
)
if NOT defined BOOST_VER (
    echo BOOST_VER is no defined
    set errorlevel=1
    goto :end
)

if "%ANDROID_TARGET_PLATFORM%" == "armv7a" (
    set ANDROID_BOOST_ABI=aapcs
) else if "%ANDROID_TARGET_PLATFORM%" == "aarch64" (
    set ANDROID_BOOST_ABI=aapcs
) else if "%ANDROID_TARGET_PLATFORM%" == "x86_64" (
    set ANDROID_BOOST_ABI=x32
) else if "%ANDROID_TARGET_PLATFORM%" == "i686" (
    set ANDROID_BOOST_ABI=x32
) else (
    echo ANDROID_TARGET_PLATFORM is unknown ^(%ANDROID_TARGET_PLATFORM%^)
    set errorlevel=1
    goto :end
)

REM ############## SETUP END

CALL %CD%\..\scripts\tpls\util\android.cmd

set BOOST_NAME=boost_%BOOST_VER:.=_%

rem set PATH=%PATH%;%MSYS_HOME%\usr\bin;%MSYS_HOME%\mingw64\bin;%TPLS_HOME%\icu.mingw64\lib

set PATH=%PATH%;%MSYS_HOME%\usr\bin\;%TPLS_HOME%\icu.android.%ANDROID_TARGET_PLATFORM%
rem set PATH=%PATH%;%ANDROID_NDK_ROOT%\toolchains\llvm\prebuilt\windows\bin
set PATH=%PATH%;%TPLS_HOME%\zlib\bin;%TPLS_HOME%\zlib\lib
set LIBRARY_PATH=%ANDROID_NDK_ROOT%\toolchains\llvm\prebuilt\windows\lib\clang\



IF NOT EXIST %BOOST_NAME%.tar.bz2 (
echo downloading %BOOST_NAME% ...
curl -L https://dl.bintray.com/boostorg/release/%BOOST_VER%/source/%BOOST_NAME%.tar.bz2 -o %BOOST_NAME%.tar.bz2
)

IF NOT EXIST %BOOST_NAME% (
echo extracting %BOOST_NAME%.tar.bz2 ...
tar -xf %BOOST_NAME%.tar.bz2
)

IF NOT EXIST %BOOST_NAME%\bjam.exe (
echo building bjam...
cd %BOOST_NAME%
call bootstrap.bat
cd ..
)

cd %BOOST_NAME%

IF EXIST bin.v2 (
    rd /S /Q bin.v2
)
IF EXIST stage (
    rd /S /Q stage
)

echo building boost...

:build
rem BROKEN thread_local support (works for mingw64!)
rem https://github.com/boostorg/config/commit/fe5e07b521e49f6cca712c801e025fed13c23979
rem https://sourceforge.net/p/mingw-w64/bugs/527/

sed 's/$#define BOOST_NO_CXX11_THREAD_LOCAL/\/\/ #define BOOST_NO_CXX11_THREAD_LOCAL/' boost/config/compiler/gcc.hpp > boost/config/compiler/gcc.hpp.fixed
move /Y boost\config\compiler\gcc.hpp.fixed boost\config\compiler\gcc.hpp

(
echo androidNDKRoot = %ANDROID_NDK_ROOT:\=/% ;
echo.
echo using clang : 8.0 : "%ANDROID_NDK_ROOT:\=/%/toolchains/llvm/prebuilt/windows-x86_64/bin/%ANDROID_CXX%" :
echo     ^<compileflags^>--sysroot=$^(androidNDKRoot^)/sysroot
echo     ^<compileflags^>-I$^(androidNDKRoot^)/sources/cxx-stl/llvm-libc++/include
echo     ^<compileflags^>-I$^(androidNDKRoot^)/sources/cxx-stl/llvm-libc++abi/include
echo     ^<compileflags^>-I$^(androidNDKRoot^)/sources/android/support/include
echo     ^<compileflags^>-I$^(androidNDKRoot^)/sysroot/usr/include/%ANDROID_HOST%
rem echo     ^<compileflags^>-g
echo     ^<compileflags^>-O3
echo     ^<compileflags^>-no-canonical-prefixes
echo     ^<linkflags^>-no-canonical-prefixes -v
echo     ^<linkflags^>-v
echo     ^<linkflags^>-fuse-ld="%ANDROID_NDK_ROOT:\=/%/toolchains/llvm/prebuilt/windows-x86_64/bin/ld.lld.exe"
echo     ^<linkflags^>-Wl,--compress-debug-sections=zlib
rem echo     ^<linkflags^>--gcc-toolchain="%ANDROID_NDK_ROOT:\=/%/toolchains/llvm/prebuilt/windows-x86_64/lib/clang/8.0.7/lib/linux"
echo     ^<cxxflags^>-std=c++17
echo     ^<cxxflags^>-fPIC
echo ;
) > project-config.jam

rem #abi "aapcs" "eabi" "ms" "n32" "n64" "o32" "o64" "sysv" "x32"
rem #architecture "x86" "ia64" "sparc" "power" "mips1" "mips2" "mips3" "mips4" "mips32" "mips32r2" "mips64" "parisc" "arm" "combined" "combined-x86-power"

rem bjam.exe -j8 -sICU_PATH="%TPLS_HOME%\icu.android.%ANDROID_TARGET_PLATFORM%" target-os=android toolset=clang-8.0 address-model=%ANDROID_ADDRESS_MODEL% architecture=%ANDROID_ARCHITECTURE% binary-format=elf abi=%ANDROID_BOOST_ABI% release link=shared runtime-link=shared --layout=versioned define=BOOST_SPIRIT_THREADSAFE --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-stacktrace

bjam.exe -j8 -d2 -sICU_PATH="%TPLS_HOME%\icu.android.%ANDROID_TARGET_PLATFORM%" target-os=android toolset=clang-8.0 address-model=%ANDROID_ADDRESS_MODEL% architecture=%ANDROID_ARCHITECTURE% binary-format=elf abi=%ANDROID_BOOST_ABI% release link=shared runtime-link=shared --layout=versioned define=BOOST_SPIRIT_THREADSAFE --with-context

rem goto :end
echo installing boost...
for %%F in (.\stage\lib\*.so.*) do (
    for /f "tokens=1,2 delims=." %%A in ("%%~nF") do (
        if "%%B" == "so" (
            ren "%%F" "%%A.%%B"
            rem echo %%~pF%%A.%%B
        )
    )
)

if NOT exist %TPLS_HOME%\boost\include (
    xcopy boost %TPLS_HOME%\boost\include\boost /s /e /q /i
)
if exist %TPLS_HOME%\boost\lib.android.%ANDROID_TARGET_PLATFORM% (
    rd /S /Q %TPLS_HOME%\boost\lib.android.%ANDROID_TARGET_PLATFORM%
)
xcopy stage\lib %TPLS_HOME%\boost\lib.android.%ANDROID_TARGET_PLATFORM% /s /e /q /i

:end
cd ..
ENDLOCAL
