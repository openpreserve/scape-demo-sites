#!/usr/bin/env bash

apt-get update
apt-get install -y apache2
apt-get install -y php5 libapache2-mod-php5
apt-get install -y git make cmake
apt-get install -y libfftw3-dev libboost-all-dev

/etc/init.d/apache2 restart
rm -rf /var/www
ln -fs /vagrant /var/www

cd /tmp
git clone https://github.com/openplanets/scape-xcorrsound.git
cd scape-xcorrsound
mkdir build && cd build
cmake ..
make package
cpack -G DEB
dpkg -i scape-xcorrsound*deb
