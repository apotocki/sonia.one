echo off
SETLOCAL
rem *********SETUP***********
set MSYS_HOME=c:\Developments\msys64
set MINGW_HOME=%MSYS_HOME%\mingw64
set BOOST_INCLUDE=C:\Developments\boost_1_68_0
set BOOST_LIB=%BOOST_INCLUDE%\stage\lib.mingw.820.cxx17
rem set JAVA_HOME=c:\Developments\jdk1.8
set ICU_HOME=c:\Developments\icu\58.2\mingw64.dist
PATH=%BOOST_LIB%;%ICU_HOME%\lib;%MINGW_HOME%\bin
rem PATH=%BOOST_LIB%;%ICU_HOME%\lib;%JAVA_HOME%\jre\bin\server;%MINGW_HOME%\bin\;d:\projects\build\mingw\build\margot-core;c:\projects\ontoquad-potocki-dev-temp2\modules\openssl\bin\
rem $(SolutionDir)../../modules/openssl/bin;c:/Developments/icu4c-51.2/lib64
rem ********END SETUP********

cd k:\projects\sonia\workdirs\tests\
k:\projects\sonia\mingw-build\build\test\sonia-test.exe --no_color_output --log_level=test_suite
rem --log_level=test_suite
ENDLOCAL
rem pause