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

set TPLS_HOME=%1

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

set ICU_BUILD_FOLDER=icu4c-%ICU_VER:/=-%-build
echo preparing build folder %ICU_BUILD_FOLDER% ...
IF EXIST %ICU_BUILD_FOLDER% (
    rm -rf %ICU_BUILD_FOLDER%
)
xcopy icu4c-%ICU_VER:/=-%\icu4c %ICU_BUILD_FOLDER% /s /e /q /i

echo patching solution sdk ...
IF NOT EXIST %ICU_BUILD_FOLDER%\source\allinone\Build.Windows.ProjectConfiguration.props.orig (
move /Y %ICU_BUILD_FOLDER%\source\allinone\Build.Windows.ProjectConfiguration.props %ICU_BUILD_FOLDER%\source\allinone\Build.Windows.ProjectConfiguration.props.orig
)
sed 's/^<WindowsTargetPlatformVersion^>8.1/^<WindowsTargetPlatformVersion^>10.0/' %ICU_BUILD_FOLDER%\source\allinone\Build.Windows.ProjectConfiguration.props.orig > %ICU_BUILD_FOLDER%\source\allinone\Build.Windows.ProjectConfiguration.props
 
echo building debug icu...
%MSBUILD_PATH%\msbuild %ICU_BUILD_FOLDER%\source\allinone\allinone.sln /p:Configuration=Debug /p:Platform="x64" /p:SkipUWP=true

echo building release icu...
%MSBUILD_PATH%\msbuild %ICU_BUILD_FOLDER%\source\allinone\allinone.sln /p:Configuration=Release /p:Platform="x64" /p:SkipUWP=true

echo installing icu...
if exist %TPLS_HOME%\icu (
rm -rf %TPLS_HOME%\icu
)
mkdir %TPLS_HOME%\icu
cp -r %ICU_BUILD_FOLDER%\include %TPLS_HOME%\icu\
cp -r %ICU_BUILD_FOLDER%\lib64 %TPLS_HOME%\icu\
rem cp -r %ICU_BUILD_FOLDER%\bin64uwp %TPLS_HOME%\icu\
cp -r %ICU_BUILD_FOLDER%\bin64 %TPLS_HOME%\icu\
rem cp -r %ICU_BUILD_FOLDER%\bin64uwp %TPLS_HOME%\icu\

echo Done.

:error
echo Failed with error code #%errorlevel%.

:end

ENDLOCAL
