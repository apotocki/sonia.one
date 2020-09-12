#!/bin/bash
set  -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export PROJECT_HOME=$DIR/../..
echo PROJECT_HOME = $PROJECT_HOME

export OPENSSL_HOME=/usr/local/opt/openssl@1.1
SIMSYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk
DEVSYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
SDKROOT=$SIMSYSROOT
#if [ -d $DIR/build ]; then
	#rm -rf $DIR/build
#fi
if [ ! -d $DIR/build ]; then
	mkdir $DIR/build
fi

#-DBOOST_BUILD_INFIX=-clang-darwin110 -DBOOST_LIB_SUFFIX=-arm64-1_74
#echo $SDKROOT
pushd $DIR/build
cmake -DCMAKE_TOOLCHAIN_FILE=$PROJECT_HOME/projects/cmake/ios.toolchain.cmake -GXcode $PROJECT_HOME/projects/cmake/ -DBUILD_TYPE=STATIC 
cmake --build . --config Release --target sonia-tests-lib -- -sdk iphoneos
popd

if false; then
if [ ! -d $DIR/build.sim ]; then
	mkdir $DIR/build.sim
fi
pushd $DIR/build.sim
cmake -DCMAKE_TOOLCHAIN_FILE=$PROJECT_HOME/projects/cmake/ios.sim.toolchain.cmake -GXcode $PROJECT_HOME/projects/cmake/ -DBUILD_TYPE=STATIC
#cmake --build . --config Release --target sonia-tests-lib -- -sdk iphonesimulator OTHERCFLAGS="-Wno-shorten-64-to-32"
cmake --build . --config Release --target sonia-tests-lib -- -sdk iphone OTHERCFLAGS="-Wno-shorten-64-to-32"
fi

#VERBOSE=1
#make -j8 sonia-tests-lib

#export SONIA_PRIME_HOME=$PROJECT_HOME/bundles/sonia-prime
#export DYLD_LIBRARY_PATH=$PROJECT_HOME/tpls/boost/lib:$DIR/build/sonia-prime
#echo $DYLD_LIBRARY_PATH
#cd $PROJECT_HOME/workdirs/tests && $DIR/build/regression-test/regression-test --no_color_output --log_level=test_suite

