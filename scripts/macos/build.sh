#!/bin/bash
set  -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export PROJECT_HOME=$DIR/../..
echo PROJECT_HOME = $PROJECT_HOME

export OPENSSL_HOME=/usr/local/opt/openssl@1.1

#if [ -d $DIR/build ]; then
	#rm -rf $DIR/build
#fi
if [ ! -d $DIR/build ]; then
	mkdir $DIR/build
fi

cd $DIR/build
cmake $PROJECT_HOME/projects/cmake/ -DBUILD_TYPE=SHARED -DBOOST_BUILD_INFIX=-clang-darwin110 -DBOOST_LIB_SUFFIX=-x64-1_74

#VERBOSE=1
make -j8 regression-test

export SONIA_PRIME_HOME=$PROJECT_HOME/bundles/sonia-prime
#export DYLD_LIBRARY_PATH=$PROJECT_HOME/tpls/boost/lib:$DIR/build/sonia-prime
#echo $DYLD_LIBRARY_PATH
cd $PROJECT_HOME/workdirs/tests && $DIR/build/regression-test/regression-test --no_color_output --log_level=test_suite

#        PROJECT_BUILD_HOME: /root/project/build
#        SONIA_PRIME_HOME: /root/project/bundles/sonia-prime
#        LD_LIBRARY_PATH: /usr/local/lib:/root/project/build/sonia-prime
#     steps:
#      - checkout
#       - run: git submodule update --init
#       - run: git submodule foreach "git checkout master"
#       - run: mkdir -p $PROJECT_HOME/tpls/lexertl14 && cp -r /tmp/lexertl14/include $PROJECT_HOME/tpls/lexertl14/
#       - run: mkdir $PROJECT_BUILD_HOME
#       - run: cd $PROJECT_BUILD_HOME && CC=gcc-9 CXX=g++-9 cmake $PROJECT_HOME/projects/cmake/ -DBUILD_TYPE=DYNAMIC -DBOOST_BUILD_INFIX=-gcc9 -DBOOST_LIB_SUFFIX=-x64-1_70
#       - run: cd $PROJECT_BUILD_HOME && make -j2 regression-test
#       - run: cd $PROJECT_HOME/workdirs/tests && $PROJECT_BUILD_HOME/regression-test/regression-test --no_color_output --log_level=test_suite
