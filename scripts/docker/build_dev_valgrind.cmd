docker rm devbuild_valgrind_on
docker run --name devbuild_valgrind_on ^
  --mount type=bind,source="%CD%\..\..",target=/opt/src ^
  --mount type=bind,source="%CD%\..\..\workdirs\tests",target=/opt/workdir ^
  --mount type=bind,source="%CD%",target=/opt/build ^
  -ti ubuntu-dev_valgrind_on:latest /opt/build/build_dev_valgrind.sh
