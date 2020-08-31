#!/bin/bash
apt-get update
apt-get install -y gnupg
printf "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu bionic main\n" >> /etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-bionic.list
apt-key add /tmp/key.asc

echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main
deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main" >> /etc/apt/sources.list
apt-get update
apt-get install -y gcc-10 g++-10 gdb valgrind clang-7 clang-tools-7 libclang-common-7-dev libclang-7-dev libclang1-7 clang-format-7 libc++-7-dev libc++abi-7-dev ssh git cmake libicu-dev zlib1g-dev libbz2-dev openssl libssl-dev default-jre
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

ln -s /usr/bin/clang-7 /usr/bin/clang
ln -s /usr/bin/clang++-7 /usr/bin/clang++

#define=BOOST_NO_CXX14_CONSTEXPR

echo "building boost"
cd /tmp/boost*
./bootstrap.sh
./b2 install -j4 -a --toolset=gcc-10 cxxflags="-std=c++17 -fPIC" address-model=64 --build-type=complete --layout=versioned define=FUSION_MAX_VECTOR_SIZE=12 define=BOOST_FUSION_INVOKE_MAX_ARITY=12 define=BOOST_SPIRIT_THREADSAFE --with-atomic --with-context --with-chrono --with-exception --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-locale --with-random --with-stacktrace --disable-filesystem2

./b2 install -j4 -a toolset=clang cxxflags="-stdlib=libc++ -std=c++17 -fPIC" linkflags="-stdlib=libc++" address-model=64 --build-type=complete --layout=versioned define=FUSION_MAX_VECTOR_SIZE=12 define=BOOST_FUSION_INVOKE_MAX_ARITY=12 define=BOOST_SPIRIT_THREADSAFE --with-atomic --with-context --with-chrono --with-exception --with-date_time --with-thread --with-program_options --with-regex --with-test --with-system --with-log --with-serialization --with-graph --with-filesystem --with-locale --with-random --with-stacktrace --disable-filesystem2

cd ..
rm -rf boost_*