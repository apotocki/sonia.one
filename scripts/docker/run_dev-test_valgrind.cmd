docker rm devrun_valgrind_on
docker run --cap-add=SYS_PTRACE --name devrun_valgrind_on ^
  --mount type=bind,source="%CD%\..\..",target=/opt/src ^
  --mount type=bind,source="%CD%\..\..\workdirs\tests",target=/opt/workdir ^
  --mount type=bind,source="%CD%",target=/opt/build ^
  -ti ubuntu-dev_valgrind_on:latest /opt/build/run_dev-test_valgrind.sh

