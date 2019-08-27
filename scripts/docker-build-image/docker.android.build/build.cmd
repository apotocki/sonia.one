@echo off
setlocal
rem ubuntu 18.04; android-ndk-r20
docker build -t u18.04r20 .
endlocal

rem docker run -ti u18.04r20:latest
