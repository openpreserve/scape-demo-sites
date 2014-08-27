#!/bin/bash

# In case you're behind a (e.g. nmlt) proxy, this is a way to have maven working.
# An example/template is available at /vagrant/proxy_settings.conf.example
if [ -f /vagrant/proxy_settings.conf ]
then
    echo "found proxy_settings, installing cntlm"
    apt-get install -y cntlm
    cp /vagrant/proxy_settings.conf /etc/cntlm.conf
    service cntlm restart
fi

# Install maven
echo "installing maven.."
apt-get install -y maven
# create a maven dir, necessary for the next steps
if [ ! -d /home/vagrant/.m2 ]
then
    mkdir /home/vagrant/.m2 && chown vagrant:vagrant /home/vagrant/.m2
fi
# check whether there's a maven settings file in /vagrant and link to it if so (in case of proxy settings, etc)
# An example/template is available at /vagrant/maven_settings.xml.example
if [ -f /vagrant/maven_settings.xml ]
then
    echo "found maven_settings, linking to them"
    ln -s /vagrant/maven_settings.xml /home/vagrant/.m2/settings.xml
fi

