#!/bin/bash
set -e
################## SETUP BEGIN
# brew install git git-lfs
export PATH="/usr/local/bin:$PATH"
ICU_VER=maint/maint-67
INSTALL_DIR="$TPLS_HOME/icu"
################## SETUP END
ICU_VER_NAME=icu4c-${ICU_VER//\//-}
if [ ! -d $ICU_VER_NAME ]; then
	echo downloading $ICU_VER_NAME ...
	git clone https://github.com/unicode-org/icu -b $ICU_VER $ICU_VER_NAME
else
	echo updating $ICU_VER_NAME ...
	cd $ICU_VER_NAME
	git pull
	cd ..
fi

################### BUILD FOR MAC OSX
ICU_BUILD_FOLDER=$ICU_VER_NAME-build

if [ ! -f $ICU_BUILD_FOLDER.success ]; then
echo preparing build folder $ICU_BUILD_FOLDER ...
if [ -d $ICU_BUILD_FOLDER ]; then
    rm -rf $ICU_BUILD_FOLDER
fi
cp -r $ICU_VER_NAME/icu4c $ICU_BUILD_FOLDER

echo "building icu (mac osx)..."
pushd $ICU_BUILD_FOLDER/source

./runConfigureICU MacOSX --enable-static --disable-shared prefix=$TPLS_HOME/icu CXXFLAGS="--std=c++17"
make -j8
make install
popd
touch $ICU_BUILD_FOLDER.success 
fi

################### BUILD FOR SYM
ICU_IOS_SYM_BUILD_FOLDER=$ICU_VER_NAME-ios.sym-build
if [ ! -f $ICU_IOS_SYM_BUILD_FOLDER.success ]; then
BUILD_DIR="$( cd "$( dirname "./" )" >/dev/null 2>&1 && pwd )"

echo preparing build folder $ICU_IOS_SYM_BUILD_FOLDER ...
if [ -d $ICU_IOS_SYM_BUILD_FOLDER ]; then
    rm -rf $ICU_IOS_SYM_BUILD_FOLDER
fi
cp -r $ICU_VER_NAME/icu4c $ICU_IOS_SYM_BUILD_FOLDER
echo "building icu (iOS)..."
pushd $ICU_IOS_SYM_BUILD_FOLDER/source

#CC=clang CXX=clang++ ./runConfigureICU MacOSX --enable-static --disable-shared prefix=$TPLS_HOME/icu.ios CXXFLAGS="--std=c++17 -target arm64-apple-ios13.5 -fembed-bitcode-marker -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
#CC=clang CXX=clang++ 

COMMON_CFLAGS="-target x86_64-$IOS_TARGET -isysroot $SIMSYSROOT/SDKs/iPhoneSimulator.sdk -I$SIMSYSROOT/SDKs/iPhoneSimulator.sdk/usr/include/"
./configure --disable-tools --disable-extras --disable-tests --disable-samples --disable-dyload --enable-static --disable-shared prefix=/Users/sasha/projects/sonia.one/tpls/icu --host=x86_64-apple-darwin --with-cross-build=$BUILD_DIR/$ICU_BUILD_FOLDER/source CFLAGS="$COMMON_CFLAGS" CXXFLAGS="$COMMON_CFLAGS -c -stdlib=libc++ -Wall --std=c++17" LDFLAGS="-stdlib=libc++ -L$SIMSYSROOT/SDKs/iPhoneSimulator.sdk/usr/lib/ -isysroot $SIMSYSROOT/SDKs/iPhoneSimulator.sdk -Wl,-dead_strip -lstdc++"

make -j8
popd
touch $ICU_IOS_SYM_BUILD_FOLDER.success 
fi

################### BUILD FOR DEV
ICU_IOS_BUILD_FOLDER=$ICU_VER_NAME-ios.dev-build
if [ ! -f $ICU_IOS_BUILD_FOLDER.success ]; then
BUILD_DIR="$( cd "$( dirname "./" )" >/dev/null 2>&1 && pwd )"

echo preparing build folder $ICU_IOS_BUILD_FOLDER ...
if [ -d $ICU_IOS_BUILD_FOLDER ]; then
    rm -rf $ICU_IOS_BUILD_FOLDER
fi
cp -r $ICU_VER_NAME/icu4c $ICU_IOS_BUILD_FOLDER
echo "building icu (iOS)..."
pushd $ICU_IOS_BUILD_FOLDER/source

COMMON_CFLAGS="-arch arm64 -target arm64-$IOS_TARGET -fembed-bitcode-marker -isysroot $DEVSYSROOT/SDKs/iPhoneOS.sdk -I$DEVSYSROOT/SDKs/iPhoneOS.sdk/usr/include/"
./configure --disable-tools --disable-extras --disable-tests --disable-samples --disable-dyload --enable-static --disable-shared prefix=/Users/sasha/projects/sonia.one/tpls/icu --host=arm-apple-darwin --with-cross-build=$BUILD_DIR/$ICU_BUILD_FOLDER/source CFLAGS="$COMMON_CFLAGS" CXXFLAGS="$COMMON_CFLAGS -c -stdlib=libc++ -Wall --std=c++17" LDFLAGS="-stdlib=libc++ -L$DEVSYSROOT/SDKs/iPhoneOS.sdk/usr/lib/ -isysroot $DEVSYSROOT/SDKs/iPhoneOS.sdk -Wl,-dead_strip -lstdc++"
make -j8
popd
touch $ICU_IOS_BUILD_FOLDER.success 
fi

if [ -d $INSTALL_DIR/lib.ios ]; then
    rm -rf $INSTALL_DIR/lib.ios
fi
mkdir $INSTALL_DIR/lib.ios

cp $ICU_IOS_SYM_BUILD_FOLDER/source/lib/libicudata.a $INSTALL_DIR/lib.ios/libicudata.sim.a
cp $ICU_IOS_BUILD_FOLDER/source/lib/libicudata.a $INSTALL_DIR/lib.ios/libicudata.dev.a
xcrun lipo -create $INSTALL_DIR/lib.ios/libicudata.sim.a $INSTALL_DIR/lib.ios/libicudata.dev.a -o $INSTALL_DIR/lib.ios/libicudata.a
