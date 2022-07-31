#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then echo "Run it as root" ; exit 1 ; fi

### [Upgrade] ###

sudo apt --allow-releaseinfo-change update
sudo apt-get upgrade -y

### [Install] ###

sudo apt install git libmicrohttpd-dev -y
git clone https://github.com/nodogsplash/nodogsplash.git
cd nodogsplash
make
sudo make install
cd ..

sudo apt install aircrack-ng -y
sudo apt install mdk3 -y

#curl -sL https://install.raspap.com | bash -s -- --repo usg-ishimura/raspap-webgui --branch master --yes
sudo ./raspbian.sh --repo usg-ishimura/raspap-webgui --branch master --yes

###  [Patch]  ###

sudo cp etc/nodogsplash/nodogsplash.conf /etc/nodogsplash/
sudo mkdir /etc/nodogsplash/htdocs/ndspage
sudo rsync -av --progress /etc/nodogsplash/htdocs/ /etc/nodogsplash/htdocs/ndspage --exclude ndspage
sudo cp -r etc/nodogsplash/htdocs/* /etc/nodogsplash/htdocs/
sudo cp nodogsplash/debian/nodogsplash.service /lib/systemd/system/
sudo systemctl enable nodogsplash.service
sudo cp etc/hostapd/hostapd.conf /etc/hostapd/
sudo cp etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf
sudo cp etc/dnsmasq.d/090_raspap.conf /etc/dnsmasq.d/
sudo cp var/www/html/index.php  /var/www/html/
sudo cp var/www/html/data.log /var/www/html/
sudo chmod 777 /var/www/html/data.log
sudo cp var/www/html/includes/* /var/www/html/includes/
sudo cp etc/raspap/hostapd/servicestart.sh /etc/raspap/hostapd/

while true; do
    read -p "Reboot is required, restart now? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

sudo reboot
