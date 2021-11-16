#!/bin/bash
set  -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export PROJECT_HOME=$DIR/../..
echo PROJECT_HOME = $PROJECT_HOME

export OPENSSL_HOME=/usr/local/opt/openssl@1.1
#XCODE_ROOT=`xcode-select -print-path`
#export DEVSYSROOT=$XCODE_ROOT/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
#export SIMSYSROOT=$XCODE_ROOT/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk


#SDKROOT=$SIMSYSROOT
#if [ -d $DIR/build ]; then
	#rm -rf $DIR/build
#fi
if [ ! -d $DIR/build ]; then
	mkdir $DIR/build
fi

pushd $DIR/build
cmake -DCMAKE_TOOLCHAIN_FILE=$PROJECT_HOME/projects/cmake/ios.toolchain.cmake -GXcode $PROJECT_HOME/projects/cmake/ -DBUILD_TYPE=STATIC 

cmake --build . --config Release --target sonia-tests-lib -- -sdk iphonesimulator
cmake --build . --config Release --target sonia-tests-lib -- -sdk iphoneos

xcrun lipo -create sonia-prime-lib/Release-iphonesimulator/libsonia-prime-lib.a sonia-prime-lib/Release-iphoneos/libsonia-prime-lib.a -o libsonia-prime-lib.a

xcrun lipo -create sonia-prime/Release-iphonesimulator/libsonia-prime.a sonia-prime/Release-iphoneos/libsonia-prime.a -o libsonia-prime.a

xcrun lipo -create sonia-tests-lib/Release-iphonesimulator/libsonia-tests-lib.a sonia-tests-lib/Release-iphoneos/libsonia-tests-lib.a -o libsonia-tests-lib.a

popd

if false; then
#-DBOOST_BUILD_INFIX=-clang-darwin110 -DBOOST_LIB_SUFFIX=-arm64-1_74
#echo $SDKROOT
pushd $DIR/build
cmake -DCMAKE_TOOLCHAIN_FILE=$PROJECT_HOME/projects/cmake/ios.toolchain.cmake -GXcode $PROJECT_HOME/projects/cmake/ -DBUILD_TYPE=STATIC 
cmake --build . --config Release --target sonia-tests-lib -- -sdk iphoneos
popd

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

