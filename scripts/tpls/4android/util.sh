#!/bin/bash
export ANDROID_NDK_ROOT=/opt/android-ndk-r20
export PATH=$PATH:$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin

if [ "$ANDROID_TARGET_PLATFORM" == "armv7a" ]; then
    export ANDROID_CC=$ANDROID_TARGET_PLATFORM-linux-androideabi$ANDROID_VER-clang
    export ANDROID_CXX=$ANDROID_TARGET_PLATFORM-linux-androideabi$ANDROID_VER-clang++
    export ANDROID_HOST=arm-linux-androideabi
else
    export ANDROID_CC=$ANDROID_TARGET_PLATFORM-linux-android$ANDROID_VER-clang
    export ANDROID_CXX=$ANDROID_TARGET_PLATFORM-linux-android$ANDROID_VER-clang++
    export ANDROID_HOST=$ANDROID_TARGET_PLATFORM-linux-android
fi

export LIBRARY_PATH=$LIBRARY_PATH:$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/lib/gcc/$ANDROID_HOST/4.9.x

if [ "$ANDROID_TARGET_PLATFORM" == "armv7a" ]; then
    export ANDROID_ADDRESS_MODEL=32
elif [ "$ANDROID_TARGET_PLATFORM" == "i686" ]; then
    export ANDROID_ADDRESS_MODEL=32
else
    export ANDROID_ADDRESS_MODEL=64
fi

if [ "$ANDROID_TARGET_PLATFORM" == "armv7a" ]; then
    export ANDROID_ARCHITECTURE=arm
elif [ "$ANDROID_TARGET_PLATFORM" == "aarch64" ]; then
    export ANDROID_ARCHITECTURE=arm
else
    export ANDROID_ARCHITECTURE=x86
fi

export ANDROID_AR=$ANDROID_HOST-ar
export ANDROID_LD=$ANDROID_HOST-ld
export ANDROID_RANLIB=$ANDROID_HOST-ranlib
