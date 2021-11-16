#!/bin/bash
set -e
################## SETUP BEGIN
BOOST_VER=1.74.0
################## SETUP END
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BOOST_NAME=boost_${BOOST_VER//./_}
echo "BOOST_NAME: $BOOST_NAME"
echo "TPLS_HOME: $TPLS_HOME"
echo "CURDIR: $PWD"
if [ ! -f $BOOST_NAME.tar.bz2 ]; then
	curl -L https://dl.bintray.com/boostorg/release/$BOOST_VER/source/$BOOST_NAME.tar.bz2 -o $BOOST_NAME.tar.bz2
fi
if [ ! -d $BOOST_NAME ]; then
	echo "extracting $BOOST_NAME.tar.bz2 ..."
	tar -xf $BOOST_NAME.tar.bz2
fi

if [ ! -f $BOOST_NAME/b2 ]; then
	echo "building bjam..."
	cd $BOOST_NAME
	./bootstrap.sh
	cd ..
fi

cd $BOOST_NAME

if true; then
if [ -d bin.v2 ]; then
	rm -rf bin.v2
fi
if [ -d stage ]; then
	rm -rf stage
fi
fi
echo patching boost...

if [ ! -f boost/serialization/unordered_collections_load_imp.hpp.orig ]; then
	mv boost/serialization/unordered_collections_load_imp.hpp boost/serialization/unordered_collections_load_imp.hpp.orig
fi
sed 's/^namespace boost/#include <boost\/serialization\/library_version_type.hpp>\
\
namespace boost/' boost/serialization/unordered_collections_load_imp.hpp.orig > boost/serialization/unordered_collections_load_imp.hpp

if [[ -f tools/build/src/user-config.jam ]]; then
	rm -f tools/build/src/user-config.jam
fi
#-isysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk
#using darwin : ios : clang++ -arch arm64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk : <striper> <root>/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/ : <architecture>arm <target-os>iphone ;
cat >> tools/build/src/user-config.jam <<EOF
using darwin : ios : clang++ -arch arm64 -fembed-bitcode-marker -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk 
: <striper> <root>/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/ 
: <target-os>iphone
;
using darwin : iossim : clang++ -arch x86_64 -L. 
: <striper> <root>/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/ 
: <architecture>x86 <target-os>iphone 
;
EOF
if [[ ! -f librt.a ]]; then
ln -s $(xcrun --sdk iphoneos --show-sdk-path)/usr/lib/libpkstart.a librt.a
fi
echo "building boost..."

#diff -u tools/build/src/tools/gcc.jam tools/build/src/tools/gcc.jam.new > ../../scripts/tpls/boost/1.74.0/gcc.jam.patch
#diff -u tools/build/src/tools/features/instruction-set-feature.jam tools/build/src/tools/features/instruction-set-feature.jam.new > ../../scripts/tpls/boost/1.74.0/instruction-set-feature.jam.patch
#diff -u tools/build/src/build/configure.jam tools/build/src/build/configure.jam.new > ../../scripts/tpls/boost/1.74.0/configure.jam.patch
#-d13
#macosx-version=iphone-13.7
SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
./b2 -j8 cxxflags="-std=c++17 -fembed-bitcode-marker" -sICU_PATH="$TPLS_HOME/icu.ios" toolset=darwin-ios address-model=64 instruction-set=arm64 architecture=arm binary-format=mach-o abi=aapcs macosx-version=iphone-13.7 link=static runtime-link=shared --layout=versioned --stagedir=stage/ios target-os=iphone define=BOOST_TEST_NO_MAIN define=BOOST_SPIRIT_THREADSAFE define=_LITTLE_ENDIAN --with-locale --with-context --with-regex

#./b2 -j8 linkflags="-arch arm64 -stdlib=libc++ -L$SDKROOT/usr/lib/ -isysroot $SDKROOT -Wl,-dead_strip -miphoneos-version-min=7.0 -lstdc++" cxxflags="-std=c++17 -arch arm64 -fembed-bitcode-marker" -sICU_PATH="$TPLS_HOME/icu.ios" toolset=darwin-ios address-model=64 binary-format=mach-o abi=aapcs macosx-version=iphone-13.7 link=static runtime-link=shared --layout=versioned --stagedir=stage/ios target-os=iphone define=BOOST_TEST_NO_MAIN define=BOOST_SPIRIT_THREADSAFE define=_LITTLE_ENDIAN --with-locale
#--with-test --with-date_time --with-thread --with-program_options --with-regex --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-stacktrace

if false; then
if [[ ! -f stage/ios/lib/libboost-a64-${BOOST_VER//./_}.a ]]; then
	rm -f stage/ios/lib/libboost-a64-${BOOST_VER//./_}.a
fi
BOOST_STATIC_LIBS=
for filename in stage/ios/lib/*.a; do
	BOOST_STATIC_LIBS="$BOOST_STATIC_LIBS $filename"
done
libtool -static -o stage/ios/lib/libboost-a64-${BOOST_VER//./_}.a $BOOST_STATIC_LIBS
mkdir -p $TPLS_HOME/boost/lib.ios
cp -R stage/ios/lib/*.a $TPLS_HOME/boost/lib.ios/
fi

#./b2 -j8 cxxflags="-std=c++17" -sICU_PATH="$TPLS_HOME/icu" release link=shared,static runtime-link=shared address-model=64 --layout=versioned architecture=x86 define=BOOST_TEST_NO_MAIN define=BOOST_SPIRIT_THREADSAFE --with-test --with-date_time --with-thread --with-program_options --with-regex --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-stacktrace

if false; then
./b2 -j8 cxxflags="-std=c++17" -sICU_PATH="$TPLS_HOME/icu" release link=static runtime-link=shared address-model=64 --layout=versioned --stagedir=stage/iossim target-os=iphone toolset=darwin-iossim macosx-version=iphonesim-13.7 architecture=x86 define=BOOST_TEST_NO_MAIN define=BOOST_SPIRIT_THREADSAFE --with-test --with-date_time --with-thread --with-program_options --with-regex --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-stacktrace

if [[ ! -f stage/iossim/lib/libboost-x64-${BOOST_VER//./_}.a ]]; then
	rm -f stage/iossim/lib/libboost-x64-${BOOST_VER//./_}.a
fi
BOOST_STATIC_LIBS=
for filename in stage/iossim/lib/*.a; do
	if [[ ${filename##*/} != "libboost-x64-${BOOST_VER//./_}.a" ]]; then
		BOOST_STATIC_LIBS="$BOOST_STATIC_LIBS $filename"
	fi
done
libtool -static -o stage/iossim/lib/libboost-x64-${BOOST_VER//./_}.a $BOOST_STATIC_LIBS
mkdir -p $TPLS_HOME/boost/lib.ios.sim
cp -R stage/iossim/lib/*.a $TPLS_HOME/boost/lib.ios.sim/
fi


#echo BOOST LIBS: $BOOST_STATIC_LIBS

if false; then
echo installing boost...
if [ -d $TPLS_HOME/$BOOST_NAME ]; then
	rm -rf $TPLS_HOME/$BOOST_NAME
fi
mkdir -p $TPLS_HOME/$BOOST_NAME/include
mkdir -p $TPLS_HOME/$BOOST_NAME/lib
cp -R boost $TPLS_HOME/$BOOST_NAME/include/
cp -R stage/lib $TPLS_HOME/$BOOST_NAME/
fi
