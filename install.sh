#!/bin/bash
#**********************************************************
#* CATEGORY    APPLICATIONS
#* GROUP       HOME AUTOMATION
#* AUTHOR      LANCE HAYNIE <LHAYNIE@HAYNIEMAIL.COM>
#* DATE        2017-08-09
#* PURPOSE     INSTALLER SCRIPT
#**********************************************************
#* MODIFICATIONS
#* 2017-08-09 - LHAYNIE - INITIAL VERSION
#* 2017-08-18 - LHAYNIE - UPDATED EXAMPLE CONFIG
#* 2017-08-22 - LHAYNIE - REMOVED SUBVERSION
#* 2017-08-22 - LHAYNIE - UPDATED CONFIG COPY PROCESS
#**********************************************************

#Jarvis Home Automation
#Copyright (C) 2017  Haynie Research & Development

#This program is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 2 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License along
#with this program; if not, write to the Free Software Foundation, Inc.,
#51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

echo "Setting Permissions"
cd /opt/
sudo chown -fR pi:pi jarvis
sudo chmod -fR 775 jarvis

echo "Updating System"
sudo apt-get update

echo "Upgrading System"
sudo apt-get upgrade --yes
sudo rpi-update

echo "Installing System Requirements"
sudo apt-get install python-pip python3-dev python3-pip mpg123 python-dev \
bison libasound2-dev libportaudio-dev python-pyaudio xorg chromium-browser \
nginx php-fpm php-apcu pianobar net-tools nmap npm php-curl \
iptables-persistent dnsutils --yes


echo "Installing Python3 Requirements"
sudo pip3 install homeassistant
sudo pip3 install sqlalchemy
sudo pip3 install appdaemon

echo "Installing Python2 Requirements"
sudo pip2 install boto3
sudo pip2 install awscli
sudo pip2 install slugify
sudo pip2 install mad
sudo pip2 install pyalsa
sudo pip2 install pyalsaaudio
sudo pip2 install apiai

echo "Installing System Services"
sudo cp -fR /opt/jarvis/resources/jarvis-* /etc/systemd/system/
sudo systemctl enable /etc/systemd/system/jarvis-*.service
sudo systemctl daemon-reload

echo "Installing Composer"
sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

echo "Setting Up Twilio SDK"
cd /opt/jarvis/web/webapi/sms
composer require twilio/sdk
cd /opt/jarvis

echo "Setting up nginx web server"
sudo /etc/init.d/nginx stop
sudo rm -fR /var/www/html
sudo ln -s /opt/jarvis/web/ /var/www/html
sudo /etc/init.d/nginx start

echo "Setting up User Config"
cp -fR /opt/jarvis/resources/user-config /home/pi/.config

echo "Setting up sound profile"
cp -fR /opt/jarvis/resources/asoundrc /home/pi/.asoundrc

echo "Setting up Configuration Files"
cd /opt/jarvis
mv secrets.yaml.example secrets.yaml
cd /opt/jarvis/stt/config
mv config.yaml.example config.yaml
cd /opt/jarvis/web/webapi/sms
mv config.php.example config.php
cd /opt/jarvis
