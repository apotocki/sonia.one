docker stop devrun
docker rm devrun
docker run --cap-add=SYS_PTRACE --name devrun ^
  --mount type=bind,source="%CD%\..\..",target=/opt/src ^
  --mount type=bind,source="%CD%\..\..\workdirs\tests",target=/opt/workdir ^
  --mount type=bind,source="%CD%",target=/opt/build ^
  -ti ubuntu-dev:latest /opt/build/run_dev-test.sh

