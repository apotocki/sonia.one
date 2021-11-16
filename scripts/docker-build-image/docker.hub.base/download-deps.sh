#!/bin/bash
export BOOST_VER=1.74.0
export BOOST_NAME=boost_${BOOST_VER//\./_}
echo "downloading boost"
cd /tmp
curl -L https://dl.bintray.com/boostorg/release/$BOOST_VER/source/$BOOST_NAME.tar.bz2 -o $BOOST_NAME.tar.bz2
echo "extracting boost"
tar -xf boost_*.tar.bz2
rm -f boost_*.bz2
echo "downloading lexertl14"
git clone https://github.com/BenHanson/lexertl14 lexertl14
