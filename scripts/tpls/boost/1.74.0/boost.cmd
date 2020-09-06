@echo off
SETLOCAL ENABLEEXTENSIONS

REM ############## SETUP
set BOOST_VER=1.74.0
if NOT defined MSYS_HOME (
    echo MSYS_HOME is no defined
    set errorlevel=1
    goto :error
)
if NOT defined WIN_KIT_VERSION (
    echo WIN_KIT_VERSION is no defined
    set errorlevel=1
    goto :error
)
REM ############## SETUP END

set TPLS_HOME=%1
set SCRIPT_HOME=%2

if /I "%~3"=="vc" (
    set BUILD_VC=1
    set BUILD_MINGW=0
) else if /I "%~3"=="mingw" (
    set BUILD_VC=0
    set BUILD_MINGW=1
) else (
    set BUILD_VC=1
    set BUILD_MINGW=1
)

echo BUILD_VC=%BUILD_VC% BUILD_MINGW=%BUILD_MINGW%

set KEY_NAME="HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots"
set VALUE_NAME=KitsRoot10

FOR /F "usebackq tokens=1,2,*" %%A IN (`REG QUERY %KEY_NAME% /v %VALUE_NAME% 2^>nul`) DO (
    set WIN_KIT_ROOT=%%C
)

set WIN_KIT_INCLUDE=%WIN_KIT_ROOT%Include\%WIN_KIT_VERSION%\ucrt
set WIN_KIT_LIB=%WIN_KIT_ROOT%Lib\%WIN_KIT_VERSION%\ucrt\x64
set BOOST_NAME=boost_%BOOST_VER:.=_%

set PATH=%MSYS_HOME%\usr\bin\;%PATH%

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

echo patching boost...

rem BROKEN thread_local support (works for mingw64!)
rem https://github.com/boostorg/config/commit/fe5e07b521e49f6cca712c801e025fed13c23979
rem https://sourceforge.net/p/mingw-w64/bugs/527/
IF NOT EXIST boost\config\compiler\gcc.hpp.orig (
move /Y boost\config\compiler\gcc.hpp boost\config\compiler\gcc.hpp.orig
)
sed 's/^^#define BOOST_NO_CXX11_THREAD_LOCAL/\/\/ #define BOOST_NO_CXX11_THREAD_LOCAL/' boost/config/compiler/gcc.hpp.orig > boost/config/compiler/gcc.hpp

IF NOT EXIST boost\context\detail\invoke.hpp.orig (
move /Y boost\context\detail\invoke.hpp boost\context\detail\invoke.hpp.orig
)
sed 's/result_of/invoke_result/' boost/context/detail/invoke.hpp.orig > boost/context/detail/invoke.hpp

IF NOT EXIST boost\serialization\unordered_collections_load_imp.hpp.orig (
move /Y boost\serialization\unordered_collections_load_imp.hpp boost\serialization\unordered_collections_load_imp.hpp.orig
)
sed 's/^^namespace boost/#include ^<boost\/serialization\/library_version_type.hpp^>\n\nnamespace boost/' boost/serialization/unordered_collections_load_imp.hpp.orig > boost/serialization/unordered_collections_load_imp.hpp

IF NOT EXIST libs\locale\build\Jamfile.v2.orig (
move /Y libs\locale\build\Jamfile.v2 libs\locale\build\Jamfile.v2.orig
copy %SCRIPT_HOME%\scripts\tpls\boost\%BOOST_VER%\locale.Jamfile.v2 libs\locale\build\Jamfile.v2
)

IF NOT EXIST libs\regex\build\Jamfile.v2.orig (
move /Y libs\regex\build\Jamfile.v2 libs\regex\build\Jamfile.v2.orig
copy %SCRIPT_HOME%\scripts\tpls\boost\%BOOST_VER%\regex.Jamfile.v2 libs\regex\build\Jamfile.v2
)

IF %BUILD_VC% NEQ 1 goto :mingwbuild

echo building boost (VC)...
b2.exe -j8 cxxflags="/std:c++latest" include="%WIN_KIT_INCLUDE%" linkflags="/LIBPATH:\"%WIN_KIT_LIB%\" " -sICU_PATH="%TPLS_HOME%\icu" toolset=%WIN_TOOLSET_NAME% release debug address-model=64 architecture=x86 define=_CRT_NONSTDC_NO_DEPRECATE define=_CRT_SECURE_NO_WARNINGS define=_SCL_SECURE_NO_WARNINGS define=_ITERATOR_DEBUG_LEVEL=0 define=BOOST_SPIRIT_THREADSAFE --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-stacktrace debug-symbols=on link=shared runtime-link=shared

:mingwbuild

IF %BUILD_MINGW% NEQ 1 goto :install

echo building boost (MINGW)...
set PATH=%MSYS_HOME%\mingw64\bin;%TPLS_HOME%\icu.mingw64\lib;%PATH%
rem set LIBRARY_PATH=%MSYS_HOME%\mingw64\bin

b2.exe -j8 cxxflags="-std=c++17" -sICU_PATH="%TPLS_HOME%\icu.mingw64" toolset=gcc release address-model=64 architecture=x86 define=BOOST_SPIRIT_THREADSAFE define=BOOST_USE_WINDOWS_H define=_WIN32_WINNT=0x0601 define=WINVER=0x0601 link=shared,static runtime-link=shared --with-regex --with-locale --with-date_time --with-thread --with-program_options --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-context --with-stacktrace

:install

echo installing boost...
if exist %TPLS_HOME%\%BOOST_NAME% (
rd /S /Q %TPLS_HOME%\%BOOST_NAME%
)

xcopy boost %TPLS_HOME%\%BOOST_NAME%\include\boost /s /e /q /i
xcopy stage\lib %TPLS_HOME%\%BOOST_NAME%\lib /s /e /q /i

cd ..
goto :end

:error
echo Failed with error code #%errorlevel%.

:end
ENDLOCAL
