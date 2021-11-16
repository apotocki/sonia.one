apt-get update
apt-get install -y software-properties-common
add-apt-repository ppa:ubuntu-toolchain-r/test
apt-get update
echo "get packages"
apt-get install -y gcc-10 g++-10 ssh git cmake libicu-dev zlib1g-dev libbz2-dev openssl libssl-dev curl
sed -i -e 's/\#PermitRootLogin[^\n]*/PermitRootLogin yes/' /etc/ssh/sshd_config
echo "root:root" | chpasswd
