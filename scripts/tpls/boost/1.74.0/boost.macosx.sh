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

if [ ! -f $BOOST_NAME/b2 ]; then
	echo "building bjam..."
	cd $BOOST_NAME
	./bootstrap.sh
	cd ..
fi

cd $BOOST_NAME

if true; then
if [ -d bin.v2 ]; then
	rm -rf bin.v2
fi
if [ -d stage ]; then
	rm -rf stage
fi
fi
echo patching boost...

if [ ! -f boost/serialization/unordered_collections_load_imp.hpp.orig ]; then
	mv boost/serialization/unordered_collections_load_imp.hpp boost/serialization/unordered_collections_load_imp.hpp.orig
fi
sed 's/^namespace boost/#include <boost\/serialization\/library_version_type.hpp>\
\
namespace boost/' boost/serialization/unordered_collections_load_imp.hpp.orig > boost/serialization/unordered_collections_load_imp.hpp

echo "building boost..."

./b2 -j8 cxxflags="-std=c++17" -sICU_PATH="$TPLS_HOME/icu" release link=shared,static runtime-link=shared address-model=64 --layout=versioned architecture=x86 define=BOOST_TEST_NO_MAIN define=BOOST_SPIRIT_THREADSAFE --with-test --with-date_time --with-thread --with-program_options --with-regex --with-system --with-log --with-serialization --with-graph --with-filesystem --with-random --with-locale --with-context --with-stacktrace
if true; then
echo installing boost...
if [ -d $TPLS_HOME/$BOOST_NAME ]; then
	rm -rf $TPLS_HOME/$BOOST_NAME
fi
mkdir -p $TPLS_HOME/$BOOST_NAME/include
mkdir -p $TPLS_HOME/$BOOST_NAME/lib
cp -R boost $TPLS_HOME/$BOOST_NAME/include/
cp -R stage/lib $TPLS_HOME/$BOOST_NAME/
fi
