#!/bin/sh
echo "start building"
export PROJECT_HOME=/opt/build
export CPLUS_INCLUDE_PATH=/usr/local/include/boost-1_73
#export GCC_DEBUG_INFO=1
#export ENABLE_ASSERTS=1

cd /opt/build
if [ ! -d build ]; then
mkdir build
fi
cd build
cmake /opt/src/projects/cmake/ -DBUILD_TYPE=DYNAMIC -DBOOST_BUILD_INFIX=-gcc7 -DBOOST_LIB_SUFFIX=-x64-1_73 -DUSE_VALGRIND=1

make -j4 dev-test
