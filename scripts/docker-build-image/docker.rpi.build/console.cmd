docker rm rpidevrun
docker run --name rpidevrun ^
  --mount type=bind,source="%CD%\..\..",target=/opt/src ^
  --mount type=bind,source="%CD%\..\..\workdirs\tests",target=/opt/workdir ^
  --mount type=bind,source="%CD%",target=/opt/build ^
  -ti u18.04test:latest /bin/bash


