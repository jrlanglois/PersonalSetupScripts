#!/bin/bash -e

# Ubuntu

sudo apt update && sudo apt upgrade && sudo apt dist-upgrade
sudo apt install -y openjdk-8-jdk openjdk-8-jre build-essential dkms jackd qjackctl automake apt-transport-https ninja-build subversion git curl python python3 gcc-multilib g++-multilib genisoimage xorriso libavahi-compat-libdnssd-dev zlib1g-dev xclip libssl-dev libcurl4-openssl-dev checkinstall zlib1g-dev libexpat1-dev sshpass libssl-dev libasound2-dev libx11-dev libxinerama-dev libxext-dev libfreetype6-dev libwebkit2gtk-4.0-dev libglu1-mesa-dev build-essential clang ladspa-sdk libjack-jackd2-dev libasound2-dev libcurl4-openssl-dev libx11-dev libxinerama-dev libxext-dev libfreetype6-dev libwebkit2gtk-4.0-dev libglu1-mesa-dev
sudo apt update && sudo apt upgrade

sudo apt install -y multiarch-support # Note that this will exclusively work on Ubuntu!

git config --global core.editor "code --wait"
git config --global init.defaultBranch main

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

# Install the latest bash (because you're insane):

git clone git://git.savannah.gnu.org/bash.git --depth=1
pushd bash
./configure
make -j6
sudo make install
popd
rm -rf bash*
bash --version # You'll probably need to reboot first...

# Install the latest vscode
# Script is from here: https://code.visualstudio.com/docs/setup/linux

if ! command -v code &> /dev/null
then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update && sudo apt upgrade && sudo apt dist-upgrade
    sudo apt install code
fi

# Browser stuff:

sudo apt install firefox

#
# Let's face it - your tinfoil hatted buffoonery already has personal data on the Googles and Facebooks. Just install Chrome and stop crying already.
#
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade
sudo apt install google-chrome-stable

# Install Consolas (best coding font imho.)

wget -O /tmp/YaHei.Consolas.1.12.zip https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/uigroupcode/YaHei.Consolas.1.12.zip
unzip /tmp/YaHei.Consolas.1.12.zip
sudo mkdir -p /usr/share/fonts/consolas
sudo mv YaHei.Consolas.1.12.ttf /usr/share/fonts/consolas/
sudo chmod 644 /usr/share/fonts/consolas/YaHei.Consolas.1.12.ttf
cd /usr/share/fonts/consolas
sudo mkfontscale && sudo mkfontdir && sudo fc-cache -fv

# Get rid of any junk:

sudo apt remove --purge libreoffice*
sudo apt remove --purge chromium*
sudo apt clean
sudo apt autoremove -y
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y

# Install Jenkins

sudo wget -qO - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
sudo ufw allow 8080
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Install Gradle (for Android)

wget https://services.gradle.org/distributions/gradle-6.7-bin.zip
sudo unzip -d /opt/gradle gradle-6.7-bin.zip
sudo echo 'export GRADLE_HOME=/opt/gradle/gradle-6.7' >> ~/.bash_aliases
sudo echo 'export PATH=${GRADLE_HOME}/bin:${PATH}' >> ~/.bash_aliases
gradle -v
