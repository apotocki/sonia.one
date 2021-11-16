@echo off
SETLOCAL ENABLEEXTENSIONS

REM ############## SETUP
if NOT defined BOOST_VER (
    echo BOOST_VER is no defined
    set errorlevel=1
    goto :error
)
if NOT defined ICU_VER (
    echo ICU_VER is no defined
    set errorlevel=1
    goto :error
)
if NOT defined ANDROID_TARGET_PLATFORM (
    echo ANDROID_TARGET_PLATFORM is no defined
    set errorlevel=1
    goto :error
)
if NOT defined ANDROID_VER (
    echo ANDROID_VER is no defined
    set errorlevel=1
    goto :error
)
REM ############## SETUP END

docker rm build4android
docker run --name build4android ^
  --mount type=bind,source="%CD%\..\..\..",target=/opt/sonia.one ^
  -e ICU_VER ^
  -e BOOST_VER ^
  -e ANDROID_TARGET_PLATFORM ^
  -e ANDROID_VER ^
  -ti u18.04r20:latest /opt/sonia.one/scripts/tpls/4android/boost.sh

goto :end

:error
echo Failed with error code #%errorlevel%.

:end
ENDLOCAL
