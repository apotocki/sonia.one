#!/bin/bash
set  -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export PROJECT_HOME=$DIR/../..
echo PROJECT_HOME = $PROJECT_HOME

export OPENSSL_HOME=/usr/local/opt/openssl@1.1

#if [ -d $DIR/build ]; then
	#rm -rf $DIR/build
#fi
if [ ! -d $DIR/build ]; then
	mkdir $DIR/build
fi

cd $DIR/build
cmake -DCMAKE_TOOLCHAIN_FILE=%PROJECT_HOME%\projects\cmake\ios.sim.toolchain.cmake -GXcode $PROJECT_HOME/projects/cmake/ -DBUILD_TYPE=STATIC -DBOOST_BUILD_INFIX=-clang-darwin110 -DBOOST_LIB_SUFFIX=-x64-1_74 -sdk iphonesimulator

#VERBOSE=1
make -j8 regression-test

export SONIA_PRIME_HOME=$PROJECT_HOME/bundles/sonia-prime
#export DYLD_LIBRARY_PATH=$PROJECT_HOME/tpls/boost/lib:$DIR/build/sonia-prime
#echo $DYLD_LIBRARY_PATH
cd $PROJECT_HOME/workdirs/tests && $DIR/build/regression-test/regression-test --no_color_output --log_level=test_suite

