#!/bin/bash
set  -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export PROJECT_HOME=$DIR/../..
export SONIA_PRIME_HOME=$PROJECT_HOME/bundles/sonia-prime
#export DYLD_LIBRARY_PATH=$PROJECT_HOME/tpls/boost/lib:$DIR/build/sonia-prime
#echo $DYLD_LIBRARY_PATH
cd $PROJECT_HOME/workdirs/tests && $DIR/build/regression-test/regression-test --no_color_output --log_level=test_suite