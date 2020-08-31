#!/bin/bash
################## SETUP BEGIN
BOOST_VER=1.74.0
################## SETUP END
BOOST_NAME=boost_${BOOST_VER//./_}
echo "BOOST_NAME: $BOOST_NAME"
echo "TPLS_HOME: $TPLS_HOME"
echo "CURDIR: $PWD"
if [ ! -f $BOOST_NAME.tar.bz2 ]; then
	curl -L https://dl.bintray.com/boostorg/release/$BOOST_VER/source/$BOOST_NAME.tar.bz2 -o $BOOST_NAME.tar.bz2
fi
if [ ! -d $BOOST_NAME ]; then
	echo "extracting $BOOST_NAME.tar.bz2 ..."
	tar -xf $BOOST_NAME.tar.bz2
fi

if [ ! -f $BOOST_NAME/bjam ]; then
	echo "building bjam..."
	cd $BOOST_NAME
	./bootstrap.sh
	cd ..
fi

cd $BOOST_NAME

if [ -d bin.v2 ]; then
	rm -rf bin.v2
fi
if [ -d stage ]; then
	rm -rf stage
fi

echo "building boost..."

#-sICU_LINK="-L$TPLS_HOME\icu\lib -licuuc -licuin -licudt"
#--prefix=/usr/local/opt/boost-1_70
./b2 -j8 cxxflags="-std=c++17" -sICU_PATH="/usr/local/opt/icu4c"  release link=shared runtime-link=shared address-model=64 --layout=versioned architecture=x86 define=BOOST_SPIRIT_THREADSAFE --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-stacktrace

echo installing boost...
if [ -d $TPLS_HOME/boost ]; then
	rm -rf $TPLS_HOME/boost
fi
mkdir -p $TPLS_HOME/boost/include
mkdir -p $TPLS_HOME/boost/lib
cp -R boost $TPLS_HOME/boost/include/
cp -R stage/lib $TPLS_HOME/boost/

