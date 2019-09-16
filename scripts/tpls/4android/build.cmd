set BOOST_VER=1.70.0
set ICU_VER=62.1
set ANDROID_TARGET_PLATFORM=x86_64
set ANDROID_VER=21

docker rm build4android
docker run --name build4android ^
  --mount type=bind,source="%CD%\..\..\..",target=/opt/sonia.one ^
  -e ICU_VER ^
  -e BOOST_VER ^
  -e ANDROID_TARGET_PLATFORM ^
  -e ANDROID_VER ^
  -ti u18.04r20:latest /opt/sonia.one/scripts/tpls/4android/boost.sh
