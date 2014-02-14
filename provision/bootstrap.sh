#!/usr/bin/env bash

##
# Bash script to provision VM, used to set up test environment.
# The is the correct home for one time builds/installations 
# required to set up the demonstrators.
#
# Be aware this script is only the first time you issue the
#    vagrant up
# command, or following a
#    vagrant destroy
#    vagrant up
# combination.  See the README for further detais.
##

# Add openplanets Bintray deb repo and udate apt repos
echo "deb http://dl.bintray.com/openplanets/opf-debian /" >> /etc/apt/sources.list 
apt-get update

# Install apache 2 and PHP 5 for demo site
apt-get install -y apache2 php5 libapache2-mod-php5

# Install firefox and Java for pagelyzer 
apt-get install -y firefox openjdk-7-jre-headless
#  Install fonts and xvfb for for virtual X window 
apt-get install -y xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic xvfb x11-apps  imagemagick

# Restart apache and link www root to the vagrant shared dir
# which is the project home directroy. This allows live edits
# on the host machine to be immediately available of the VM.
/etc/init.d/apache2 restart
rm -rf /var/www
ln -fs /vagrant /var/www


# Install tools for downloading and building xcorrsound 
apt-get install -y git make cmake
apt-get install -y libfftw3-dev libboost-all-dev

# Build xcorrsound package in temp
cd /tmp
git clone https://github.com/openplanets/scape-xcorrsound.git
cd scape-xcorrsound
mkdir build && cd build
cmake ..
make package
cpack -G DEB

# Install xcorrsound package
dpkg -i scape-xcorrsound*deb

# Download and install jpylyzer package
apt-get install -y jpylyzer

# Download Selenium to /var/lib/selenium
mkdir -p /var/lib/selenium
wget -q -O /var/lib/selenium/selenium-server-standalone-2.39.0.jar http://selenium.googlecode.com/files/selenium-server-standalone-2.39.0.jar 

# Copy the Pagelyzer Jar to /var/lib/pagelyzer
mkdir -p /var/lib/pagelyzer
cp /vagrant/lib/jPagelyzer.jar /var/lib/pagelyzer

# Copy the Selenium Xvfb script to init.d and register it
cp /vagrant/provision/services/xvfb-sel /etc/init.d/xvfb-sel
chmod +x /etc/init.d/xvfb-sel
update-rc.d xvfb-sel defaults
service xvfb-sel start

# Copy the pagelyzer Xvfb script to init.d and register it
cp /vagrant/provision/services/xvfb-pag /etc/init.d/xvfb-pag
chmod +x /etc/init.d/xvfb-pag
update-rc.d xvfb-pag defaults
service xvfb-pag start

# Copy the selenium script to init.d and register it
cp /vagrant/provision/services/selenium /etc/init.d/selenium
chmod +x /etc/init.d/selenium
update-rc.d selenium defaults
service selenium start

