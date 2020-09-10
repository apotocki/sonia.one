#!/bin/bash
set -e
################## SETUP BEGIN
# brew install git git-lfs
BZIP2_VER=1.0.6
INSTALL_DIR="$TPLS_HOME/bzip2"
################## SETUP END
BZIP2_VER_NAME=bzip2-$BZIP2_VER
if [[ ! -f bzip2-$BZIP2_VER.tgz ]]; then
	echo downloading $BZIP2_VER_NAME ...
	curl -L https://sourceforge.net/projects/bzip2/files/bzip2-$BZIP2_VER.tar.gz/download -o $BZIP2_VER_NAME.tgz
fi

if [[ -d $BZIP2_VER_NAME ]]; then
	rm -rf $BZIP2_VER_NAME
fi
echo extracting $BZIP2_VER_NAME.tgz ...
tar -xf $BZIP2_VER_NAME.tgz

FDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cp $FDIR/Makefile $BZIP2_VER_NAME/Makefile

SIMSYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk
DEVSYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk

echo building $BZIP2_VER_NAME ...
pushd $BZIP2_VER_NAME
make -f Makefile libbz2.a ISYSROOT=$SIMSYSROOT

echo installing $BZIP2_VER_NAME ...
if [[ -d $TPLS_HOME/bzip2 ]]; then
	rm -rf $TPLS_HOME/bzip2
fi

mkdir $TPLS_HOME/bzip2
mkdir $TPLS_HOME/bzip2/include
mkdir $TPLS_HOME/bzip2/lib.ios
mkdir $TPLS_HOME/bzip2/lib.iossim
cp bzlib.h $TPLS_HOME/bzip2/include/
cp libbz2.a $TPLS_HOME/bzip2/lib.iossim/

popd
