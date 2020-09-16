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

pushd $BZIP2_VER_NAME

if [[ -d $TPLS_HOME/bzip2 ]]; then
	rm -rf $TPLS_HOME/bzip2
fi

mkdir $TPLS_HOME/bzip2
mkdir $TPLS_HOME/bzip2/include
mkdir $TPLS_HOME/bzip2/lib
mkdir $TPLS_HOME/bzip2/lib.ios
cp bzlib.h $TPLS_HOME/bzip2/include/

echo building $BZIP2_VER_NAME ...

make -f Makefile clean
make -f Makefile libbz2.a CFLAGS=
cp libbz2.a $TPLS_HOME/bzip2/lib/ 

make -f Makefile clean
make -f Makefile libbz2.a CFLAGS="-target x86_64-$IOS_TARGET-simulator -isysroot $SIMSYSROOT/SDKs/iPhoneSimulator.sdk"
cp libbz2.a $TPLS_HOME/bzip2/lib.ios/libbz2.sym.a

make -f Makefile clean
make -f Makefile libbz2.a CFLAGS="-fembed-bitcode-marker -target arm64-$IOS_TARGET -isysroot $DEVSYSROOT/SDKs/iPhoneOS.sdk"
cp libbz2.a $TPLS_HOME/bzip2/lib.ios/libbz2.dev.a

xcrun lipo -create $TPLS_HOME/bzip2/lib.ios/libbz2.sym.a $TPLS_HOME/bzip2/lib.ios/libbz2.dev.a -o $TPLS_HOME/bzip2/lib.ios/libbz2.a

make -f Makefile clean
popd
