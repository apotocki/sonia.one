#!/bin/sh
echo "start building"
export PROJECT_HOME=/opt/build
#export GCC_DEBUG_INFO=1
#export ENABLE_ASSERTS=1

cd /opt/build
if [ ! -d build ]; then
mkdir build
fi
cd build
cmake /opt/src/projects/cmake/ -DBUILD_TYPE=DYNAMIC

make -j4 dev-test

