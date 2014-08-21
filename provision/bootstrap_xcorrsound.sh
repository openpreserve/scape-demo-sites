#!/bin/bash

# Install tools for downloading and building xcorrsound
apt-get install -y make cmake ruby-ronn git
apt-get install -y libfftw3-dev libboost-all-dev

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

datadir="$SCRIPT_PATH/sample"
fileServer="https://sbforge.org/downloads/scape/scape_xcorrsound_jenkins_files"

echo "Getting demo site sample content from $fileServer"
mkdir -p "$datadir"
cd "$datadir"
wget -r -np -nd -N -q "$fileServer/"
cd ..

cd "$datadir" && find -type f -not -name '*.wav' | xargs rm

ln -s "$datadir/P1_1800_2000_040712_001.mp3.ffmpeg.short.wav" "$datadir/before.wav"
ln -s "$datadir/P1_1800_2000_040712_001.mp3.mpeg321.short.wav" "$datadir/after.wav"

