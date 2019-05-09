#!/bin/sh
echo "run angel"
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export SONIA_PRIME_HOME=/opt/src/bundles/sonia-prime
cd /opt/workdir/
/opt/build/build/angel/angel -c config.json
