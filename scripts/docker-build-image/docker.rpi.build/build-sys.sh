apt-get update
apt-get install -y gnupg
printf "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu bionic main\n" >> /etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-bionic.list

#https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x60c317803a41ba51845e371a1e9377a2ba9ef27f
#from https://launchpad.net/~ubuntu-toolchain-r/+archive/ubuntu/test
apt-key add /tmp/key.asc

apt-get update
apt-get install -y gcc-10 g++-10 gperf bison flex texinfo help2man make libncurses5-dev python3-dev autoconf automake libtool libtool-bin gawk wget bzip2 xz-utils unzip patch git

git clone http://github.com/crosstool-ng/crosstool-ng crosstool-ng-1.24.0
cd crosstool-ng-1.24.0
git checkout tags/crosstool-ng-1.24.0
./bootstrap
CC=gcc-10 CXX=g++-10 ./configure --prefix=/opt/cross-1.24
make install
export PATH=/opt/cross-1.24/bin:$PATH
cd ..
rm -rf crosstool-ng-1.24.0
mkdir /opt/cross-1.24/src

mkdir /opt/rpi
mv /tmp/gcc.10.1.config /opt/rpi/.config
cd /opt/rpi
ct-ng build
cd /
rm -rf /opt/rpi
