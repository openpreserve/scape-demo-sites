# we need a browser, as pagelyzer uses firefox this should do
sudo apt-get install -y firefox

# install xvfb, which contains xvfb-run
sudo apt-get install -y xvfb

# using python's nose test framework
sudo apt-get install -y python-nose

# pip is a package manager for python
sudo apt-get install -y python-pip

# install python's selenium bindings
pip install selenium

echo "==========================================================================================="
echo ""
echo "Running high-level blackbox tests.."

# running the selenium tests in a virtual framebuffer connecting to the standalone selenium server
xvfb-run --server-num=1 nosetests -v /vagrant/tests/*.py
