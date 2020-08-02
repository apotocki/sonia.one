@echo off
SETLOCAL ENABLEEXTENSIONS

set TPLS_HOME=%1

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
REM ############## SETUP END

set BOOST_NAME=boost_%BOOST_VER:.=_%

set PATH=%MSYS_HOME%\mingw64\bin;%MSYS_HOME%\usr\bin;%TPLS_HOME%\icu.mingw64\lib;%PATH%
set LIBRARY_PATH=%MSYS_HOME%\mingw64\bin

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

:build
rem BROKEN thread_local support (works for mingw64!)
rem https://github.com/boostorg/config/commit/fe5e07b521e49f6cca712c801e025fed13c23979
rem https://sourceforge.net/p/mingw-w64/bugs/527/

sed 's/$#define BOOST_NO_CXX11_THREAD_LOCAL/\/\/ #define BOOST_NO_CXX11_THREAD_LOCAL/' boost/config/compiler/gcc.hpp > boost/config/compiler/gcc.hpp.fixed
move /Y boost\config\compiler\gcc.hpp.fixed boost\config\compiler\gcc.hpp

b2.exe -j8 -sICU_PATH="%TPLS_HOME%\icu.mingw64" -sICU_LINK="-L%TPLS_HOME%\icu.mingw64\lib -licuuc.dll -licuin.dll -licudt.dll" toolset=gcc release link=shared runtime-link=shared address-model=64 architecture=x86 define=BOOST_SPIRIT_THREADSAFE define=BOOST_USE_WINDOWS_H define=_WIN32_WINNT=0x0601 define=WINVER=0x0601 --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-stacktrace

rem goto :end
echo installing boost...
rem if exist %TPLS_HOME%\boost (
rem rd /S /Q %TPLS_HOME%\boost
rem )

rem xcopy boost %TPLS_HOME%\boost\include\boost /s /e /q /i
xcopy stage\lib %TPLS_HOME%\boost\lib /s /e /q /i

cd ..
goto :end

:error
echo Failed with error code #%errorlevel%.

:end
ENDLOCAL
