
###
# flint
###
FLINT_VERSION=flint-0.6.0
DPTUTILS_VERSION=dptutils-0.0.1


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
