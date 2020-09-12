#!/bin/bash
PROJECT_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export TPLS_HOME=$PROJECT_HOME/tpls

ICU_VER=maint-67
BOOST_VER=1.74.0
OPENSSL_VER=OpenSSL_1_1_1-stable
BZIP2_VER=1.0.6

if [ ! -d $PROJECT_HOME/build ]; then
mkdir $PROJECT_HOME/build
fi

cd $PROJECT_HOME/build

#IOS_SDK_PATH=$(xcrun --sdk iphoneos --show-sdk-path)
#IOSSIM_SDK_PATH=$(xcrun --sdk iphonesimulator --show-sdk-path)
#echo $IOS_SDK_PATH
#echo $IOSSIM_SDK_PATH
#XCODE_ROOT=`xcode-select -print-path`
#echo $XCODE_ROOT
#echo $XCODE_ROOT/Platforms/iPhoneOS.platform/Developer
#echo $XCODE_ROOT/Platforms/iPhoneSimulator.platform/Developer



#$PROJECT_HOME/scripts/tpls/icu/$ICU_VER/icu.macosx.sh
#$PROJECT_HOME/scripts/tpls/openssl/$OPENSSL_VER/openssl.ios.sh
##$PROJECT_HOME/scripts/tpls/boost/$BOOST_VER/boost.macosx.sh
#$PROJECT_HOME/scripts/tpls/boost/$BOOST_VER/boost.mac.sh
$PROJECT_HOME/scripts/tpls/bzip2/$BZIP2_VER/bzip2.sh
#$PROJECT_HOME/scripts/tpls/macos/lexertl.sh
