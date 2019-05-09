#!/bin/sh
echo "run dev-test"
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export SONIA_PRIME_HOME=/opt/src/bundles/sonia-prime
cd /opt/workdir
#/opt/build/build/dev-test/dev-test --no_color_output --log_level=test_suite
#gdb -ex=r --args /opt/build/build/dev-test/dev-test --no_color_output --log_level=test_suite
valgrind --max-stackframe=201737488 /opt/build/build/dev-test/dev-test --no_color_output --log_level=test_suite

