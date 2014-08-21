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

<<<<<<< HEAD
source /vagrant/provision/bootstrap_jpylyzer.sh
=======
###
# flint
###
FLINT_VERSION=flint-0.6.0
DPTUTILS_VERSION=dptutils-0.0.1

# clone dptuils & flint from the repository
echo "[for flint] setting up flint.."
echo "[for flint] installing dependency: dptutils.."
cd /home/vagrant
sudo -u vagrant git clone https://github.com/bl-dpt/dptutils.git
cd dptutils
sudo -u vagrant git checkout $DPTUTILS_VERSION
sudo -u vagrant mvn clean install -DskipTests=true

echo "[for flint] installing jhove.."
sudo -u vagrant mvn install:install-file -Dfile=/vagrant/flint/jhove-1.10.jar -Dversion=1.10 -DgroupId=org.opf-labs.jhove -DartifactId=jhove -Dpackaging=jar

echo "[for flint] now installing flint.."
cd /home/vagrant
sudo -u vagrant git clone https://github.com/openplanets/flint.git
cd flint
sudo -u vagrant git checkout $FLINT_VERSION
# build the minimal set of modules
sudo -u vagrant mvn -pl .,flint-toolwrappers,flint-core,flint-pdf,flint-epub,flint-register,flint-cli clean install -DskipTests=true
# remove the version bit from the flint-cli jar name
sudo -u vagrant cp flint-cli/target/flint-cli-*-jar-with-dependencies.jar flint.jar
echo "[for flint] created /home/vagrant/flint/flint.jar"
>>>>>>> lecs/flint-fixes

source /vagrant/provision/bootstrap_flint.sh

source /vagrant/provision/bootstrap_matchbox.sh

source /vagrant/provision/bootstrap_xcorrsound.sh
