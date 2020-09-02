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

echo building boost...



rem goto :end
rem echo installing boost...
rem if exist %TPLS_HOME%\boost (
rem rd /S /Q %TPLS_HOME%\boost
rem )

rem xcopy boost %TPLS_HOME%\boost\include\boost /s /e /q /i
rem xcopy stage\lib %TPLS_HOME%\boost\lib /s /e /q /i

cd ..
goto :end

:error
echo Failed with error code #%errorlevel%.

:end
ENDLOCAL
