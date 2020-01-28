#!/bin/bash -ex

#wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.root

# debconf-apt-progress seems to hang so get rid of it too
#which debconf-apt-progress
#mv "$(which debconf-apt-progress)" /bin/no_debconf-apt-progress

git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole
cd "Pi-hole/automated install/"
bash basic-install.sh

su - installer

echo 'Docker install successful'

