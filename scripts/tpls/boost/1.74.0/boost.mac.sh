#!/bin/bash
set -e
################## SETUP BEGIN
BOOST_VER=1.74.0
################## SETUP END
BOOST_NAME=boost_${BOOST_VER//./_}
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

merge_archives()
{
    BUILDDIR="$1"

    if [[ ! -f $BUILDDIR/libboost.a ]]; then
		rm -f $BUILDDIR/libboost.a
	fi
	BOOST_STATIC_LIBS=
	for filename in $BUILDDIR/*.a; do
		if [[ ${filename##*/} != "libboost.a" ]]; then
			BOOST_STATIC_LIBS="$BOOST_STATIC_LIBS $filename"
		fi
	done
	libtool -static -o $BUILDDIR/libboost.a $BOOST_STATIC_LIBS
}

if [ ! -f $BOOST_NAME.tar.bz2 ]; then
	curl -L https://dl.bintray.com/boostorg/release/$BOOST_VER/source/$BOOST_NAME.tar.bz2 -o $BOOST_NAME.tar.bz2
fi
if [ ! -d $BOOST_NAME ]; then
	echo "extracting $BOOST_NAME.tar.bz2 ..."
	tar -xf $BOOST_NAME.tar.bz2
fi

if [ ! -f $BOOST_NAME/b2 ]; then
	pushd $BOOST_NAME
	./bootstrap.sh
	popd
fi

pushd $BOOST_NAME
if true; then

if [ -d bin.v2 ]; then
	rm -rf bin.v2
fi
if [ -d stage ]; then
	rm -rf stage
fi

echo patching boost...

if [ ! -f boost/serialization/unordered_collections_load_imp.hpp.orig ]; then
	mv boost/serialization/unordered_collections_load_imp.hpp boost/serialization/unordered_collections_load_imp.hpp.orig
fi
sed 's/^namespace boost/#include <boost\/serialization\/library_version_type.hpp>\
\
namespace boost/' boost/serialization/unordered_collections_load_imp.hpp.orig > boost/serialization/unordered_collections_load_imp.hpp

if [ ! -f tools/build/src/tools/gcc.jam.orig ]; then
	cp -f tools/build/src/tools/gcc.jam tools/build/src/tools/gcc.jam.orig
else
	cp -f tools/build/src/tools/gcc.jam.orig tools/build/src/tools/gcc.jam
fi
patch tools/build/src/tools/gcc.jam $SCRIPT_DIR/gcc.jam.patch

if [ ! -f tools/build/src/tools/features/instruction-set-feature.jam.orig ]; then
	cp -f tools/build/src/tools/features/instruction-set-feature.jam tools/build/src/tools/features/instruction-set-feature.jam.orig
else
	cp -f tools/build/src/tools/features/instruction-set-feature.jam.orig tools/build/src/tools/features/instruction-set-feature.jam
fi
patch tools/build/src/tools/features/instruction-set-feature.jam $SCRIPT_DIR/instruction-set-feature.jam.patch

if [ ! -f tools/build/src/build/configure.jam.orig ]; then
	cp -f tools/build/src/build/configure.jam tools/build/src/build/configure.jam.orig
else
	cp -f tools/build/src/build/configure.jam.orig tools/build/src/build/configure.jam
fi
patch tools/build/src/build/configure.jam $SCRIPT_DIR/configure.jam.patch

LIBS_TO_BUILD="--with-test --with-date_time --with-thread --with-program_options --with-regex --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-stacktrace"

#LIBS_TO_BUILD="--with-context --with-regex --with-locale"
B2_BUILD_OPTIONS="release link=static runtime-link=shared define=BOOST_TEST_NO_MAIN define=BOOST_SPIRIT_THREADSAFE"
#--layout=versioned

if [[ -f tools/build/src/user-config.jam ]]; then
	rm -f tools/build/src/user-config.jam
fi
cat >> tools/build/src/user-config.jam <<EOF
using darwin : ios : clang++ -arch arm64 -fembed-bitcode-marker -isysroot $DEVSYSROOT/SDKs/iPhoneOS.sdk
: <striper> <root>$DEVSYSROOT 
: <architecture>arm <target-os>iphone 
;
using darwin : iossim : clang++ -arch x86_64 
: <striper> <root>$SIMSYSROOT 
: <architecture>x86 <target-os>iphone 
;
using darwin : : 
: 
: <target-os>darwin 
;
EOF

./b2 -j8 --stagedir=stage/macosx cxxflags="-std=c++17" -sICU_PATH="$TPLS_HOME/icu" target-os=darwin address-model=64 architecture=x86 $B2_BUILD_OPTIONS $LIBS_TO_BUILD

merge_archives "stage/macosx/lib"

./b2 -j8 --stagedir=stage/ios cxxflags="-std=c++17 -fembed-bitcode-marker" -sICU_PATH="$TPLS_HOME/icu.ios" toolset=darwin-ios address-model=64 instruction-set=arm64 architecture=arm binary-format=mach-o abi=aapcs macosx-version=iphone-13.7 target-os=iphone define=_LITTLE_ENDIAN $B2_BUILD_OPTIONS $LIBS_TO_BUILD

merge_archives "stage/ios/lib"

./b2 -j8 --stagedir=stage/iossim cxxflags="-std=c++17 -fembed-bitcode-marker" -sICU_PATH="$TPLS_HOME/icu" toolset=darwin-iossim address-model=64 architecture=x86 target-os=iphone macosx-version=iphonesim-13.7 architecture=x86 $B2_BUILD_OPTIONS $LIBS_TO_BUILD

merge_archives "stage/iossim/lib"
fi
echo installing boost...
if [ -d $TPLS_HOME/$BOOST_NAME ]; then
	rm -rf $TPLS_HOME/$BOOST_NAME
fi
mkdir -p $TPLS_HOME/$BOOST_NAME/include
mkdir -p $TPLS_HOME/$BOOST_NAME/lib.ios
cp -R boost $TPLS_HOME/$BOOST_NAME/include/
mv stage/macosx/lib $TPLS_HOME/$BOOST_NAME/

xcrun lipo -create stage/iossim/lib/libboost.a stage/ios/lib/libboost.a -o $TPLS_HOME/$BOOST_NAME/lib.ios/libboost.a

popd
