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

if true; then
BUILD_DIR="$( cd "$( dirname "./" )" >/dev/null 2>&1 && pwd )"

ICU_IOS_BUILD_FOLDER=$ICU_VER_NAME-ios-build
echo preparing build folder $ICU_IOS_BUILD_FOLDER ...
if [ -d $ICU_IOS_BUILD_FOLDER ]; then
    rm -rf $ICU_IOS_BUILD_FOLDER
fi
cp -r $ICU_VER_NAME/icu4c $ICU_IOS_BUILD_FOLDER
echo "building icu (iOS)..."
pushd $ICU_IOS_BUILD_FOLDER/source

#CC=clang CXX=clang++ ./runConfigureICU MacOSX --enable-static --disable-shared prefix=$TPLS_HOME/icu.ios CXXFLAGS="--std=c++17 -target arm64-apple-ios13.5 -fembed-bitcode-marker -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
#CC=clang CXX=clang++ 
ARCH="arm64"
DEVTARGET=arm64-apple-ios13.5
SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
./configure --disable-tools --disable-extras --disable-tests --disable-samples --disable-dyload --enable-static --disable-shared prefix=/Users/sasha/projects/sonia.one/tpls/icu.ios --host=arm-apple-darwin --with-cross-build=$BUILD_DIR/$ICU_BUILD_FOLDER/source CFLAGS="-fembed-bitcode-marker -isysroot $SDKROOT -I$SDKROOT/usr/include/ -arch $ARCH -target $DEVTARGET" CXXFLAGS="-c -stdlib=libc++ -Wall --std=c++17 -fembed-bitcode-marker -isysroot $SDKROOT -arch $ARCH -target $DEVTARGET" LDFLAGS="-stdlib=libc++ -L$SDKROOT/usr/lib/ -isysroot $SDKROOT -Wl,-dead_strip -miphoneos-version-min=7.0 -lstdc++"
make -j8 install
popd
fi
