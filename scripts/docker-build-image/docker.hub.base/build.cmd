@echo off
setlocal
docker build -t u18.04g10.1b1.74 .
endlocal

rem docker run -ti u18.04g10.1b1.74:latest
rem docker tag u18.04g10.1b1.74:latest sonia.one.test.environment:u18.04g10.1b1.74
rem docker tag sonia.one.test.environment:u18.04g10.1b1.74 sane22222/sonia.one.test.environment:u18.04g10.1b1.74
rem docker push sane22222/sonia.one.test.environment:u18.04g10.1b1.74