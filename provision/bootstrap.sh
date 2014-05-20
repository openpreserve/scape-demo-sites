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

echo "install scape demo tools ..."

# Add openplanets Bintray deb repo and udate apt repos
#echo "deb http://dl.bintray.com/openplanets/opf-debian /" >> /etc/apt/sources.list 
apt-get update

# Install apache 2, Python module and PHP 5 for demo site
apt-get install -y apache2 php5 libapache2-mod-php5 libapache2-mod-python

# Install firefox and Java for pagelyzer 
#apt-get install -y firefox openjdk-7-jre-headless
#  Install fonts and xvfb for for virtual X window 
#apt-get install -y xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic xvfb x11-apps  imagemagick

# Restart apache and link www root to the vagrant shared dir
# which is the project home directroy. This allows live edits
# on the host machine to be immediately available of the VM.
/etc/init.d/apache2 restart
rm -rf /var/www
ln -fs /vagrant /var/www

# Copy the FLint Jar to /var/lib/flint -- TODO: debian-package flint
mkdir -p /var/lib/flint
cp /vagrant/lib/flint.jar /var/lib/flint

###
# Install matchbox
###

# Remove some old packages that we need to replace for Matchbox build.
echo "removing conflicting matchbox dependencies ..."
#cd /tmp
sudo apt-get remove -y libopencv-dev libcv-dev libopencv-features2d-dev libhighgui-dev
echo "installing matchbox build dependencies."
sudo apt-get install -y libboost-all-dev zlib1g-dev libjpeg8-dev libpng12-dev libtiff4-dev libjasper-dev libgtk2.0-dev python-numpy libopenexr-dev

echo "copy matchbox debian package."
wget -q -O scape-matchbox_1.0.0_incl_libs.deb "http://dl.bintray.com/ait/ait-repository/scape-matchbox_1.0.0_incl_libs.deb"

# Install tools for downloading matchbox sources 
apt-get install -y git 

# Install matchbox package
echo "install matchbox debian package..."
dpkg -i scape-matchbox*deb

# Install matchbox
echo "install matchbox ..."
cd /home/vagrant

# Load matchbox sources from Github
echo "load matchbox sources"
git clone https://github.com/openplanets/matchbox.git
echo "matchbox cloned"
cd matchbox/

echo "check matchbox commands..."
ldd /usr/bin/mb_extractfeatures
/usr/bin/mb_extractfeatures --help
ldd /usr/bin/mb_compare
/usr/bin/mb_compare --help
ldd /usr/bin/mb_train
/usr/bin/mb_train --help

# Move the matchbox Python scripts to pyshared
echo "move the matchbox Python scripts to pyshared..."
mkdir -p /usr/share/pyshared/matchbox
chmod +x /home/vagrant/matchbox/Python/*.py
mv /home/vagrant/matchbox/Python/*.py /usr/share/pyshared/matchbox/

# link from python 2.7 dist-packages
echo "create links to the matchbox Python scripts..."
mkdir -p /usr/lib/python2.7/dist-packages/matchbox
ln -fs /usr/share/pyshared/matchbox/FindDuplicates.py /usr/lib/python2.7/dist-packages/matchbox/FindDuplicates.py
ln -fs /usr/share/pyshared/matchbox/CompareCollections.py /usr/lib/python2.7/dist-packages/matchbox/CompareCollections.py
ln -fs /usr/share/pyshared/matchbox/MatchboxLib.py /usr/lib/python2.7/dist-packages/matchbox/MatchboxLib.py 

# Create sym-links for the commands for now
ln -fs /usr/share/pyshared/matchbox/FindDuplicates.py /usr/bin/FindDuplicates
ln -fs /usr/share/pyshared/matchbox/CompareCollections.py /usr/bin/CompareCollections

# Add some test data for now
echo "add test data..."
apt-get install -y unzip
mkdir /matchbox
unzip /vagrant/deploy/matchbox/matchbox-samples.zip -d /matchbox
chown -R www-data:www-data /matchbox/matchbox-samples

echo "test FindDuplicates..."
FindDuplicates -h
