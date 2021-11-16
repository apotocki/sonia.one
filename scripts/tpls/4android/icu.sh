#!/bin/bash

source /opt/sonia.one/scripts/tpls/4android/util.sh

TPLS_HOME=/opt/sonia.one/tpls
BUILD_HOME=/opt/sonia.one/build

cd /opt/sonia.one/build
if [ ! -f icu4c-$ICU_VER-src.tgz ]; then
echo downloading icu4c-$ICU_VER ...
curl https://github.com/unicode-org/icu/releases/download/release-%ICU_VER:.=-%/icu4c-%ICU_VER:.=_%-src.tgz -o icu4c-$ICU_VER-src.tgz
#curl -L http://download.icu-project.org/files/icu4c/$ICU_VER/icu4c-${ICU_VER//\./_}-src.tgz -o icu4c-$ICU_VER-src.tgz
fi

if [ -d icu ]; then
rm -rf icu
fi

if [ ! -d icu4c-$ICU_VER-src ]; then
echo extracting icu4c-$ICU_VER-src.tgz ...
tar -xf icu4c-$ICU_VER-src.tgz
mv icu icu4c-$ICU_VER-src
fi

if [ ! -d icu.ubuntu.build ]; then
    echo "building icu (cross build environment)..."
    if [ -d icu.ubuntu.build.tmp ]; then
        rm -rf icu.ubuntu.build.tmp
    fi
    mkdir icu.ubuntu.build.tmp
    cd icu.ubuntu.build.tmp
    ../icu4c-$ICU_VER-src/source/runConfigureICU Linux prefix=$TPLS_HOME/icu.ubuntu CFLAGS="-O3" CXXFLAGS="--std=c++17"
    make -j4
    cd ..
    mv icu.ubuntu.build.tmp icu.ubuntu.build
fi

if [ -d icu.android.$ANDROID_TARGET_PLATFORM.build ]; then
    rm -rf icu.android.$ANDROID_TARGET_PLATFORM.build
fi
mkdir icu.android.$ANDROID_TARGET_PLATFORM.build
cd icu.android.$ANDROID_TARGET_PLATFORM.build

if [ -d $TPLS_HOME/icu.android.$ANDROID_TARGET_PLATFORM ]; then
    rm -rf $TPLS_HOME/icu.android.$ANDROID_TARGET_PLATFORM
fi

if [ "$ANDROID_TARGET_PLATFORM" == "armv7a" ]; then
    CFG_CFLAGS=-march=armv7-a -mfloat-abi=softfp -mfpu=neon
    CFG_LDFLAGS=-march=armv7-a -Wl,--fix-cortex-a8
elif [ "$ANDROID_TARGET_PLATFORM" == "i686" ]; then
    CFG_CFLAGS=-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32
    CFG_LDFLAGS=
elif [ "$ANDROID_TARGET_PLATFORM" == "x86_64" ]; then
    CFG_CFLAGS=-march=x86-64
    CFG_LDFLAGS=
elif [ "$ANDROID_TARGET_PLATFORM" == "aarch64" ]; then
    CFG_CFLAGS=
    CFG_LDFLAGS=
else
    echo "ANDROID_TARGET_PLATFORM is unknown ($ANDROID_TARGET_PLATFORM)"
    exit 1
fi

echo "building icu.android.$ANDROID_TARGET_PLATFORM..."

../icu4c-$ICU_VER-src/source/configure --prefix=$TPLS_HOME/icu.android.$ANDROID_TARGET_PLATFORM \
    --host=$ANDROID_HOST \
    -with-cross-build=$BUILD_HOME/icu.ubuntu.build \
    CFLAGS="-O3 $CFG_CFLAGS" \
    CXXFLAGS="--std=c++17 $CFG_CFLAGS" \
    LDFLAGS="$CFG_LDFLAGS" \
    CC=$ANDROID_CC \
    CXX=$ANDROID_CXX \
    AR=$ANDROID_AR \
    RINLIB=$ANDROID_RANLIB \
    --with-data-packaging=archive

make -j4 && make install
