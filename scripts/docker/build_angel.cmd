docker rm devbuild
docker run --name devbuild ^
  --mount type=bind,source="%CD%\..\..",target=/opt/src ^
  --mount type=bind,source="%CD%\..\..\workdirs\angel",target=/opt/workdir ^
  --mount type=bind,source="%CD%",target=/opt/build ^
  -ti ubuntu-dev:latest /opt/build/build_angel.sh
