#!/bin/bash
cd /tmp/boost*
./bootstrap.sh

cd /tmp/boost*

if [ ! -f boost/serialization/unordered_collections_load_imp.hpp.orig ]; then
	mv boost/serialization/unordered_collections_load_imp.hpp boost/serialization/unordered_collections_load_imp.hpp.orig
fi
sed 's/^namespace boost/#include <boost\/serialization\/library_version_type.hpp>\n\nnamespace boost/' boost/serialization/unordered_collections_load_imp.hpp.orig > boost/serialization/unordered_collections_load_imp.hpp
 
echo "building boost" 

echo "using gcc : 10.1 : g++-10 ; " >> tools/build/src/user-config.jam
./b2 install -j4 -a --toolset=gcc-10.1 release cxxflags="-std=c++17 -fPIC" address-model=64 link=shared,static runtime-link=shared --layout=versioned define=BOOST_TEST_NO_MAIN define=FUSION_MAX_VECTOR_SIZE=12 define=BOOST_FUSION_INVOKE_MAX_ARITY=12 define=BOOST_SPIRIT_THREADSAFE --with-context --with-exception --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-locale --with-random --with-stacktrace --disable-filesystem2
cd ..
rm -rf boost_*