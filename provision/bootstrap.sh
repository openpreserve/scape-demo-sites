#!/usr/bin/env bash

SCRIPT_PATH=$(dirname $(readlink -f $0 ) )


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
echo "deb http://dl.bintray.com/openplanets/opf-debian /" >> /etc/apt/sources.list
apt-get update

# Install apache 2, Python module, PHP 5 and java runtime 7 for demo site
apt-get install -y apache2 php5 libapache2-mod-php5 libapache2-mod-python openjdk-7-jre-headless

echo "upload_max_filesize = 50M" >> /etc/php5/apache2/php.ini
echo " post_max_size = 192M" >> /etc/php5/apache2/php.ini


# Restart apache and link www root to the vagrant shared dir
# which is the project home directroy. This allows live edits
# on the host machine to be immediately available of the VM.
/etc/init.d/apache2 restart
rm -rf /var/www
ln -fs /vagrant /var/www



# Install firefox and Java for pagelyzer
#apt-get install -y firefox openjdk-7-jre-headless
#  Install fonts and xvfb for for virtual X window
#apt-get install -y xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic xvfb x11-apps  imagemagick

# Install tools for downloading (matchbox, flint) sources
apt-get install -y git

 source /vagrant/provision/bootstrap_jpylyzer.sh

 source /vagrant/provision/bootstrap_flint.sh

 source /vagrant/provision/bootstrap_matchbox.sh

 source /vagrant/provision/bootstrap_xcorrsound.sh

 #source /vagrant/provision/bootstrap_pagelyzer.sh
