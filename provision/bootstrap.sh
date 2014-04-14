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
apt-get install -y --force-yes jpylyzer

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

###
# Install matchbox
###

# Remove some old packages that we need to replace for Matchbox build.
echo "Removing conflicting matchbox dependencies ..."
cd /tmp
sudo apt-get remove -y libopencv-dev libcv-dev libopencv-features2d-dev libhighgui-dev
echo "Installing Matchbox build dependencies."
sudo apt-get install -y libboost-all-dev zlib1g-dev libjpeg8-dev libpng12-dev libtiff4-dev libjasper-dev libgtk2.0-dev python-numpy libopenexr-dev


# Clone GitHub project and move into 
echo "Cloning Matchbox from GitHub."
git clone https://github.com/openplanets/matchbox.git
cd matchbox/

# Set env var for OPEN CV version
OPENCVVER=2.4.6.1
# Download and extract Open CV source!
echo "Downloading OpenCV source."
wget -O opencv-${OPENCVVER}.tar.gz http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/${OPENCVVER}/opencv-${OPENCVVER}.tar.gz && tar zxf opencv-${OPENCVVER}.tar.gz

# Set up build directories
mkdir opencv-bin
cd opencv-$OPENCVVER
mkdir build
cd build

# Start Open CV Build cmake and make install
echo "Building OpenCV..."
cmake .. -DCMAKE_INSTALL_PREFIX=../../opencv-bin
make
make install

# This is the path to the installed OpenCVConfig.cmake
# NOTE: a *full* path to the file should be passed to cmake, hence the addition of `pwd`
cd ../..
mkdir build
cd build
pwd
echo "Building Matchbox."
cmake .. -DOpenCV_DIR=`pwd`/../opencv-bin/share/OpenCV/
make
cpack
dpkg -i scape-matchbox*deb

echo "Checking matchbox installation."
mb_extractfeatures --help
mb_compare --help
mb_train --help

# Move the matchbox Python scripts to pyshared
mkdir -p /usr/share/pyshared/matchbox
chmod +x /tmp/matchbox/Python/*.py
mv /tmp/matchbox/Python/*.py /usr/share/pyshared/matchbox/

# link from python 2.7 dist-packages
mkdir -p /usr/lib/python2.7/dist-packages/matchbox
ln -fs /usr/share/pyshared/matchbox/FindDuplicates.py /usr/lib/python2.7/dist-packages/matchbox/FindDuplicates.py
ln -fs /usr/share/pyshared/matchbox/CompareCollections.py /usr/lib/python2.7/dist-packages/matchbox/CompareCollections.py
ln -fs /usr/share/pyshared/matchbox/MatchboxLib.py /usr/lib/python2.7/dist-packages/matchbox/MatchboxLib.py 

# Create sym-links for the commands for now
ln -fs /usr/share/pyshared/matchbox/FindDuplicates.py /usr/bin/FindDuplicates
ln -fs /usr/share/pyshared/matchbox/CompareCollections.py /usr/bin/CompareCollections

# Replace faulty library names in script
#sed -i.bak s/"\"extractfeatures\""/"\"mb_extractfeatures\""/g /usr/share/pyshared/matchbox/FindDuplicates.py
#sed -i.bak s/"\"compare\""/"\"mb_compare\""/g /usr/share/pyshared/matchbox/FindDuplicates.py
#sed -i.bak s/"\"train\""/"\"mb_train\""/g /usr/share/pyshared/matchbox/FindDuplicates.py

# Add some test data for now
apt-get install -y unzip
mkdir /matchbox
unzip /vagrant/deploy/matchbox/matchbox-samples.zip -d /matchbox
chown -R www-data:www-data /matchbox/matchbox-samples

FindDuplicates -h