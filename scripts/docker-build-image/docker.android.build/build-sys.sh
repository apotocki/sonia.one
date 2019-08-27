apt-get update
apt-get install -y ssh git cmake curl unzip gcc g++
sed -i -e 's/\#PermitRootLogin[^\n]*/PermitRootLogin yes/' /etc/ssh/sshd_config
echo "root:root" | chpasswd
echo "downloading boost"
cd /opt
curl -L https://dl.google.com/android/repository/android-ndk-r20-linux-x86_64.zip -o android-ndk-r20-linux-x86_64.zip
