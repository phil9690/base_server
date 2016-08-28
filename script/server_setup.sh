# CENTOS 7 server setup

# Create user
echo "******INITIAL SERVER SETUP******"
echo "******ADMIN USER CREATION*******"
echo "Type the admin username"
read user

adduser $user

# Set user password
echo "Set the password for $user"
read password

passwd $password

# Give user admin privildges
gpasswd -a $user wheel

# Switch to new user
su - $user

# Set up ssh keys
# Make ssh directory on new user
mkdir .ssh
# Restrict folder permissions
chmod 700 .ssh

# Create authorized keys file
touch .ssh/authorized_keys

# Get user to paste output of cat .ssh/id_rsa.pub from their machine
echo "Copy your local machines ssh key with the following command"
echo "cat .ssh/id_rsa.pub"
echo "and copy the output below:"
read sshkey


# Restrict authorized keys file
chmod 600 .ssh/authorized_keys

# Return to root user
exit

# Configure ssh daemon
#vi /etc/ssh/sshd_config

# Change
# PermitRootLogin yes
# MaxAuthTries = 6
#to
#PermitRootLogin no
#MaxAuthTries = 3

sed 's/#\?\(PermitRootLogin\s*\).*$/\1 no/' /etc/ssh/sshd_config > temp.txt
mv -f temp.txt /etc/ssh/sshd_config
sed 's/#\?\(MaxAuthTries\s*\).*$/\1 3/' /etc/ssh/sshd_config > temp.txt
mv -f temp.txt /etc/ssh/sshd_config

# Restart ssh
systemctl reload sshd

# Get ip address
ipaddress=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

echo "Logging out of root..."
echo "Log back in with the following command:"
echo "ssh $user@$ipaddress"

# Logout of root
exit

# Log in as the new user that was set up using
ssh username@ipaddress

# Setting up the firewall - USE IPTABLES

# Configure Timezones
# list available timezones
timedatectl list-timezones

# set timezone Europe/London
timedatectl set-timezone region/timezone

# Configure NTP synchronization
#install ntp
sudo yum install ntp

# start ntp
sudo systemctl start ntpd

# enable ntp on startup
sudo systemctl enable ntpd

# Create a swap file for extra ram
sudo fallocate -l 4G /swapfile

# restrict swapfile access
sudo chmod 600 /swapfile

# tell system to format file for swap
sudo mkswap /swapfile

# tell system it can use the swap file
sudo swapon /swapfile

# use swapfile automatically on boot
sudo sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab'

# log into root
sudo su -

# remove firewalld and use iptables
# stop firewalld and disable
systemctl stop firewalld
systemctl mask firewalld

# install iptables
yum -y install iptables-services

# enable iptables
systemctl enable iptables
systemctl enable ip6tables
systemctl start iptables
systemctl start ip6tables

# flush iptables rules
iptables -F

# apply iptables ruleset file here

# save iptables ruleset applied and restart
iptables-save > /etc/sysconfig/iptables
systemctl restart iptables

# update the server
yum -y update

# installing ruby with rbenv
# install dependencies
yum -y install git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel

# make sure user that will be running the site is logged in
# install rbenv
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

# get rbenv ruby builds
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

# install ruby - add version input here
rbenv install 2.3.1

# get rid of ruby auto doc install
echo "gem: --no-ri --no-rdoc" > ~/.gemrc

# install bundler
gem install bundler

# install rails
gem install rails

#install shims for all Ruby executables known to rbenv, which will allow you to use the executables.
rbenv rehash

# install nodejs
yum -y install epel-release
yum -y install nodejs

# install mariadb or postgres
systemctl start mariadb
systemctl enable mariadb

# run mysql secure install script
mysql_secure_installation

#install mysql gem
gem install mysql2

rbenv rehash

#installing passenger and nginx

