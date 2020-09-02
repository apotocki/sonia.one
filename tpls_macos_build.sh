#!/bin/bash
PROJECT_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export TPLS_HOME=$PROJECT_HOME/tpls

if [ ! -d $PROJECT_HOME/build ]; then
mkdir $PROJECT_HOME/build
fi

cd $PROJECT_HOME/build
$PROJECT_HOME/scripts/tpls/macos/boost.sh
#$PROJECT_HOME/scripts/tpls/macos/lexertl.sh
