@echo off
SETLOCAL

set TPLS_HOME=%1

REM ############## SETUP
rem expected system variables:
rem set MSYS_HOME=
rem set MSVS_BUILD=
set OPENSSL_VER=1.1.1-stable
REM ############## SETUP END

set PATH=%PATH%;%MSYS_HOME%\mingw64\bin;%MSYS_HOME%\usr\bin

IF NOT EXIST openssl-%OPENSSL_VER% (
echo downloading openssl-%OPENSSL_VER% ...
git clone https://github.com/openssl/openssl -b OpenSSL_%OPENSSL_VER:.=_% openssl-%OPENSSL_VER%
) else (
echo updating openssl-%OPENSSL_VER% ...
cd openssl-%OPENSSL_VER%
git pull
cd ..
)

echo building openssl-%OPENSSL_VER% ...
call "%MSVS_BUILD%\vcvars64.bat"
cd openssl-%OPENSSL_VER%
perl Configure --prefix="%TPLS_HOME%\openssl" --openssldir="%TPLS_HOME%/openssl/ssl" VC-WIN64A || goto :error
nmake || goto :error
rem nmake test || goto :error

echo installing openssl-%OPENSSL_VER% ...
if exist %TPLS_HOME%\openssl (
rm -rf %TPLS_HOME%\openssl
)

nmake install || goto :error
goto :end

:error
echo Failed with error code #%errorlevel%.

:end
cd ..
ENDLOCAL
