#!/bin/bash
PROJECT_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export TPLS_HOME=$PROJECT_HOME/tpls
ICU_VER=maint-67
BOOST_VER=1.74.0

if [ ! -d $PROJECT_HOME/build ]; then
mkdir $PROJECT_HOME/build
fi



cd $PROJECT_HOME/build

#$PROJECT_HOME/scripts/tpls/icu/$ICU_VER/icu.macosx.sh
$PROJECT_HOME/scripts/tpls/boost/$BOOST_VER/boost.macosx.sh

#$PROJECT_HOME/scripts/tpls/macos/lexertl.sh
