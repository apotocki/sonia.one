#!/bin/bash
echo "get packages"
apt-get update
apt-get install -y gcc g++ gdb valgrind ssh git cmake libicu-dev zlib1g-dev libbz2-dev openssl libssl-dev default-jre
sed -i -e 's/\#PermitRootLogin[^\n]*/PermitRootLogin yes/' /etc/ssh/sshd_config
echo "root:root" | chpasswd

echo "extracting boost"
cd /tmp
tar -xf boost_*.tar.bz2
rm -f boost_*.bz2

#echo "extracting java"
#tar -xf jre-*.tar.gz
#rm -f jre-*.tar.gz
#mv jre* jre1.8.0
#mkdir /usr/java 
#mv jre1.8.0 /usr/java/

echo "building boost"
cd /tmp/boost*
./bootstrap.sh
./bjam install -j4 -a cxxflags="-std=c++17 -fPIC" address-model=64 --build-type=complete --layout=tagged define=FUSION_MAX_VECTOR_SIZE=12 define=BOOST_FUSION_INVOKE_MAX_ARITY=12 define=BOOST_SPIRIT_THREADSAFE --with-atomic --with-context --with-chrono --with-exception --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-locale --with-random --with-fiber --disable-filesystem2
cd ..
rm -rf boost_*