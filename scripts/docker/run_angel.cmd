docker rm devrun
docker run --cap-add=SYS_PTRACE --name devrun ^
  -p 8081-8083:8081-8083 ^
  --mount type=bind,source="%CD%\..\..",target=/opt/src ^
  --mount type=bind,source="%CD%\..\..\workdirs\angel",target=/opt/workdir ^
  --mount type=bind,source="%CD%",target=/opt/build ^
  -ti ubuntu-dev:latest /opt/build/run_angel.sh
