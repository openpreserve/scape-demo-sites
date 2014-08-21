
###
# flint
###
FLINT_VERSION=flint-0.6.0


# in case you're behind a (e.g. nmlt) proxy, this is a way to have maven working
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
if [ -f /vagrant/maven_settings.xml ]
then
    echo "found maven_settings, linking to them"
    ln -s /vagrant/maven_settings.xml /home/vagrant/.m2/settings.xml
fi


# Install jdk7 (for flint)
apt-get install -y openjdk-7-jdk

# set java7 as default (for flint)
echo "[flint] setting java-7-openjdk-amd64 as default"
sudo update-alternatives --set java /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java


# clone dptuils & flint from the repository
echo "[for flint] setting up flint.."
echo "[for flint] installing dependency: dptutils.."
cd /home/vagrant
sudo -u vagrant git clone https://github.com/bl-dpt/dptutils.git
cd dptutils
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
