#!/bin/sh
echo "run regression-test"
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export SONIA_PRIME_HOME=/opt/src/bundles/sonia-prime
cd /opt/workdir
/opt/build/build/regression-test/regression-test --no_color_output --log_level=test_suite
