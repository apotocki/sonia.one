#!/bin/bash

source /opt/sonia.one/scripts/tpls/4android/util.sh

TPLS_HOME=/opt/sonia.one/tpls
BUILD_HOME=/opt/sonia.one/build

BOOST_NAME=boost_${BOOST_VER//\./_}

cd /opt/sonia.one/build
if [ ! -f $BOOST_NAME.tar.bz2 ]; then
    echo downloading $BOOST_NAME ...
    curl -L https://dl.bintray.com/boostorg/release/$BOOST_VER/source/$BOOST_NAME.tar.bz2 -o $BOOST_NAME.tar.bz2
fi

if [ ! -d $BOOST_NAME ]; then
    echo extracting $BOOST_NAME.tar.bz2 ...
    tar -xf $BOOST_NAME.tar.bz2
fi

if [ ! -f $BOOST_NAME/bjam ]; then
    echo building bjam...
    cd $BOOST_NAME
    ./bootstrap.sh
    cd ..
fi

if [ "$ANDROID_TARGET_PLATFORM" == "armv7a" ]; then
    ANDROID_BOOST_ABI=aapcs
elif [ "$ANDROID_TARGET_PLATFORM" == "aarch64" ]; then
    ANDROID_BOOST_ABI=aapcs
elif [ "$ANDROID_TARGET_PLATFORM" == "i686" ]; then
    ANDROID_BOOST_ABI=x32
elif [ "$ANDROID_TARGET_PLATFORM" == "x86_64" ]; then
    ANDROID_BOOST_ABI=x32
else
    echo "ANDROID_TARGET_PLATFORM is unknown ($ANDROID_TARGET_PLATFORM)"
    exit 1
fi

cd $BOOST_NAME
if [ -d bin.v2 ]; then
    rm -rf bin.v2
fi
if [ -d stage ]; then
    rm -rf stage
fi

echo building boost...

echo "androidNDKRoot = $ANDROID_NDK_ROOT ;

using clang : 8.0 : $ANDROID_CXX :
    <compileflags>--sysroot=\$(androidNDKRoot)/sysroot
    <compileflags>-I\$(androidNDKRoot)/sources/cxx-stl/llvm-libc++/include
    <compileflags>-I\$(androidNDKRoot)/sources/cxx-stl/llvm-libc++abi/include
    <compileflags>-I\$(androidNDKRoot)/sources/android/support/include
    <compileflags>-I\$(androidNDKRoot)/sysroot/usr/include/$ANDROID_HOST
    <compileflags>-O3
    #<compileflags>-g
    <compileflags>-no-canonical-prefixes
    <linkflags>-no-canonical-prefixes -v
    <linkflags>-v
    #<linkflags>-fuse-ld=$ANDROID_LD
    <linkflags>-Wl,--compress-debug-sections=zlib
    <linkflags>--gcc-toolchain="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/lib/clang/8.0.7/lib/linux"
    <cxxflags>-std=c++17
    <cxxflags>-fPIC
;" > project-config.jam

./bjam -j8 -sICU_PATH="$TPLS_HOME/icu.android.$ANDROID_TARGET_PLATFORM" target-os=android toolset=clang-8.0 address-model=$ANDROID_ADDRESS_MODEL architecture=$ANDROID_ARCHITECTURE binary-format=elf abi=$ANDROID_BOOST_ABI release link=shared runtime-link=shared --layout=versioned define=BOOST_SPIRIT_THREADSAFE --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-fiber --with-stacktrace

#./bjam -j8 -sICU_PATH="$TPLS_HOME/icu.android.$ANDROID_TARGET_PLATFORM" target-os=android toolset=clang-8.0 address-model=$ANDROID_ADDRESS_MODEL architecture=$ANDROID_ARCHITECTURE binary-format=elf abi=$ANDROID_BOOST_ABI release link=shared runtime-link=shared --layout=versioned define=BOOST_SPIRIT_THREADSAFE --with-context

echo installing boost...

if [ ! -d $TPLS_HOME/boost ]; then
    mkdir $TPLS_HOME/boost
fi
if [ ! -d $TPLS_HOME/boost/include ]; then
    mkdir $TPLS_HOME/boost/include
    cp -r boost $TPLS_HOME/boost/include/
fi
if [ -d $TPLS_HOME/boost/lib.android.$ANDROID_TARGET_PLATFORM ]; then
    rm -rf $TPLS_HOME/boost/lib.android.$ANDROID_TARGET_PLATFORM
fi
mkdir $TPLS_HOME/boost/lib.android.$ANDROID_TARGET_PLATFORM
cp stage/lib/*.so $TPLS_HOME/boost/lib.android.$ANDROID_TARGET_PLATFORM/
cp stage/lib/*.a $TPLS_HOME/boost/lib.android.$ANDROID_TARGET_PLATFORM/
