#!/bin/bash

################################ SETUP
export IOS_TARGET=apple-ios13.5
ICU_VER=maint-67
BOOST_VER=1.74.0
OPENSSL_VER=OpenSSL_1_1_1-stable
BZIP2_VER=1.0.6

################################ AUXILARY
PROJECT_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export TPLS_HOME=$PROJECT_HOME/tpls

XCODE_ROOT=`xcode-select -print-path`
export DEVSYSROOT=$XCODE_ROOT/Platforms/iPhoneOS.platform/Developer
export SIMSYSROOT=$XCODE_ROOT/Platforms/iPhoneSimulator.platform/Developer

#IOS_SDK_PATH=$(xcrun --sdk iphoneos --show-sdk-path)
#IOSSIM_SDK_PATH=$(xcrun --sdk iphonesimulator --show-sdk-path)
#echo $IOS_SDK_PATH
#echo $IOSSIM_SDK_PATH


if [ ! -d $PROJECT_HOME/build ]; then
mkdir $PROJECT_HOME/build
fi

cd $PROJECT_HOME/build

#$PROJECT_HOME/scripts/tpls/bzip2/$BZIP2_VER/bzip2.mac.sh
#$PROJECT_HOME/scripts/tpls/icu/$ICU_VER/icu.mac.sh
#$PROJECT_HOME/scripts/tpls/boost/$BOOST_VER/boost.mac.sh
$PROJECT_HOME/scripts/tpls/openssl/$OPENSSL_VER/openssl.mac.sh

##$PROJECT_HOME/scripts/tpls/boost/$BOOST_VER/boost.macosx.sh

#$PROJECT_HOME/scripts/tpls/macos/lexertl.sh
