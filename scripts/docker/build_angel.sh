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
cmake /opt/src/projects/cmake/ -DBUILD_TYPE=DYNAMIC -DBOOST_BUILD_INFIX=-gcc7 -DBOOST_LIB_SUFFIX=-x64-1_70

make -j4 angel
