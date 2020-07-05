@echo off
SETLOCAL ENABLEEXTENSIONS

set TPLS_HOME=%1

set KEY_NAME="HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots"
set VALUE_NAME=KitsRoot10

FOR /F "usebackq tokens=1,2,*" %%A IN (`REG QUERY %KEY_NAME% /v %VALUE_NAME% 2^>nul`) DO (
    set WIN_KIT_ROOT=%%C
)

REM ############## SETUP
if NOT defined MSYS_HOME (
    echo MSYS_HOME is no defined
    set errorlevel=1
    goto :error
)
if NOT defined BOOST_VER (
    echo BOOST_VER is no defined
    set errorlevel=1
    goto :error
)
if NOT defined WIN_KIT_VERSION (
    echo WIN_KIT_VERSION is no defined
    set errorlevel=1
    goto :error
)
REM ############## SETUP END

set WIN_KIT_INCLUDE=%WIN_KIT_ROOT%Include\%WIN_KIT_VERSION%\ucrt
set WIN_KIT_LIB=%WIN_KIT_ROOT%Lib\%WIN_KIT_VERSION%\ucrt\x64
set BOOST_NAME=boost_%BOOST_VER:.=_%

set PATH=%PATH%;%MSYS_HOME%\usr\bin\

IF NOT EXIST %BOOST_NAME%.tar.bz2 (
echo downloading %BOOST_NAME% ...
curl -L https://dl.bintray.com/boostorg/release/%BOOST_VER%/source/%BOOST_NAME%.tar.bz2 -o %BOOST_NAME%.tar.bz2
)

IF NOT EXIST %BOOST_NAME% (
echo extracting %BOOST_NAME%.tar.bz2 ...
tar -xf %BOOST_NAME%.tar.bz2
)

IF NOT EXIST %BOOST_NAME%\b2.exe (
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

rem BROKEN thread_local support (works for mingw64!)
rem https://github.com/boostorg/config/commit/fe5e07b521e49f6cca712c801e025fed13c23979
rem https://sourceforge.net/p/mingw-w64/bugs/527/
sed 's/^#define BOOST_NO_CXX11_THREAD_LOCAL/\/\/ #define BOOST_NO_CXX11_THREAD_LOCAL/' boost/config/compiler/gcc.hpp > boost/config/compiler/gcc.hpp.fixed
move /Y boost\config\compiler\gcc.hpp.fixed boost\config\compiler\gcc.hpp

rem -sICU_LINK="-LIBPATH:%TPLS_HOME%\icu\lib icuuc.lib icuin.lib icudt.lib"
b2.exe -j8 include="%WIN_KIT_INCLUDE%" linkflags="/LIBPATH:\"%WIN_KIT_LIB%\" " -sICU_PATH="%TPLS_HOME%\icu" toolset=%WIN_TOOLSET_NAME% release debug address-model=64 architecture=x86 define=_CRT_NONSTDC_NO_DEPRECATE define=_CRT_SECURE_NO_WARNINGS define=_SCL_SECURE_NO_WARNINGS define=_ITERATOR_DEBUG_LEVEL=0 define=BOOST_SPIRIT_THREADSAFE -sICU_PATH="%TPLS_HOME%\icu" --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-fiber --with-stacktrace debug-symbols=on link=shared runtime-link=shared

set PATH=%MSYS_HOME%\mingw64\bin;%TPLS_HOME%\icu.mingw64\lib;%PATH%
set LIBRARY_PATH=%MSYS_HOME%\mingw64\bin

rem -sICU_LINK="-L%TPLS_HOME%\icu.mingw64\lib -licuuc -licuin -licudt"
b2.exe -j8 cxxflags="-std=c++17" -sICU_PATH="%TPLS_HOME%\icu.mingw64" toolset=gcc release link=shared runtime-link=shared address-model=64 architecture=x86 define=BOOST_SPIRIT_THREADSAFE define=BOOST_USE_WINDOWS_H define=_WIN32_WINNT=0x0601 define=WINVER=0x0601 --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-fiber --with-stacktrace

echo installing boost...
if exist %TPLS_HOME%\boost (
rd /S /Q %TPLS_HOME%\boost
)

xcopy boost %TPLS_HOME%\boost\include\boost /s /e /q /i
xcopy stage\lib %TPLS_HOME%\boost\lib /s /e /q /i

cd ..
goto :end

:error
echo Failed with error code #%errorlevel%.

:end
ENDLOCAL
