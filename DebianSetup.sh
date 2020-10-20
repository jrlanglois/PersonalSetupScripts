#!/bin/bash -e

# Ubuntu

sudo apt update && sudo apt upgrade && sudo apt dist-upgrade
sudo apt-get install -y build-essential dkms automake apt-transport-https ninja-build subversion git curl python python3 multiarch-support gcc-multilib g++-multilib genisoimage xorriso libavahi-compat-libdnssd-dev zlib1g-dev xclip libssl-dev libcurl4-openssl-dev checkinstall zlib1g-dev libexpat1-dev sshpass libssl-dev libasound2-dev libx11-dev libxinerama-dev libxext-dev libfreetype6-dev libwebkit2gtk-4.0-dev libglu1-mesa-dev

# Start off from the home folder.

cd ~/

# Install the latest git:

git clone https://github.com/git/git --depth=1
pushd git
sudo make -j6 prefix=/usr/local all
sudo make -j6 prefix=/usr/local install
popd
rm -rf git*
git --version

# Install the latest cmake:

git clone https://github.com/Kitware/CMake --depth=1
pushd CMake
./bootstrap && make -j6
sudo make install
popd
sudo rm -rf CMake*
cmake --version

# Install the latest Ninja:

git clone https://github.com/ninja-build/ninja --depth=1
pushd ninja
CXX=clang++ ./configure.py
./configure.py --bootstrap
sudo rm -rf /usr/bin/ninja
sudo mv ninja /usr/bin/ninja
popd
sudo rm -rf ninja*
ninja --version

# Install the latest curl:

git clone https://github.com/curl/curl --depth=1
pushd curl
cmake -G "Ninja" .
ninja
sudo ninja install
popd
rm -rf curl*
curl --version

# Install the latest vscode
# Script is from here: https://code.visualstudio.com/docs/setup/linux

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade
sudo apt install code

# Browser stuff:

sudo apt install firefox

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade
sudo apt install google-chrome-stable

# Get rid of any junk:

sudo apt remove --purge libreoffice*
sudo apt remove --purge chromium*
sudo apt clean
sudo apt autoremove
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade

