#!/bin/bash
set -e
################## SETUP BEGIN
# brew install git git-lfs
export PATH="/usr/local/bin:$PATH"
ICU_VER=maint/maint-67
INSTALL_DIR="$TPLS_HOME/icu"
################## SETUP END
ICU_VER_NAME=icu4c-${ICU_VER//\//-}
if [ ! -d $ICU_VER_NAME ]; then
	echo downloading $ICU_VER_NAME ...
	git clone https://github.com/unicode-org/icu -b $ICU_VER $ICU_VER_NAME
else
	echo updating $ICU_VER_NAME ...
	cd $ICU_VER_NAME
	git pull
	cd ..
fi

ICU_BUILD_FOLDER=$ICU_VER_NAME-build
#if false; then
echo preparing build folder $ICU_BUILD_FOLDER ...
if [ ! -d $ICU_BUILD_FOLDER ]; then
    rm -rf $ICU_BUILD_FOLDER
fi
cp -r $ICU_VER_NAME/icu4c $ICU_BUILD_FOLDER
#fi

echo building icu...
pushd $ICU_BUILD_FOLDER/source

./runConfigureICU MacOSX --enable-static --disable-shared prefix=$INSTALL_DIR CXXFLAGS="--std=c++17"
make -j8 install

popd
