#!/bin/bash
set -e
################## SETUP BEGIN
# brew install git git-lfs
OPENSSL_VER=OpenSSL_1_1_1-stable

INSTALL_DIR="$TPLS_HOME/openssl"
################## SETUP END
OPENSSL_VER_NAME=${OPENSSL_VER//.//-}
if [ ! -d $OPENSSL_VER_NAME ]; then
	echo downloading $OPENSSL_VER ...
	git clone https://github.com/openssl/openssl -b $OPENSSL_VER $OPENSSL_VER_NAME
else
	echo updating $OPENSSL_VER ...
	cd $OPENSSL_VER_NAME
	git pull
	cd ..
fi

echo building $OPENSSL_VER ...
pushd $OPENSSL_VER_NAME

#./Configure LIST
./Configure --prefix="$TPLS_HOME/openssl.iossim" --openssldir="$TPLS_HOME/openssl.iossim/ssl" no-shared iossimulator-xcrun
make install
#--cross-compile-prefix=
#perl Configure --prefix="%TPLS_HOME%\openssl" --openssldir="%TPLS_HOME%/openssl/ssl" VC-WIN64A || goto :error
popd
