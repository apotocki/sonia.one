#!/bin/bash
cd /tmp/boost*
./bootstrap.sh
echo "using gcc : 9.1 : g++-9 ; " >> tools/build/src/user-config.jam
./bjam install -j4 -a --toolset=gcc-9.1 cxxflags="-std=c++17 -fPIC" address-model=64 --build-type=complete --layout=versioned define=FUSION_MAX_VECTOR_SIZE=12 define=BOOST_FUSION_INVOKE_MAX_ARITY=12 define=BOOST_SPIRIT_THREADSAFE --with-context --with-exception --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-locale --with-random --with-fiber --with-stacktrace --disable-filesystem2
cd ..
rm -rf boost_*