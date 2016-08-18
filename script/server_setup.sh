# CENTOS 7 server setup

# Create user
adduser username

# Set user password
passwd username

# Give user admin privildges
gpasswd -a username wheel

# Switch to new user
su - username

# Set up ssh keys
# Make ssh directory on new user
mkdir .ssh
# Restrict folder permissions
chmod 700 .ssh

# Create authorized keys file
touch .ssh/authorized_keys

# Get user to paste output of cat .ssh/id_rsa.pub from their machine

# Restrict authorized keys file
chmod 600 .ssh/authorized_keys

# Return to root user
exit

# Configure ssh daemon
vi /etc/ssh/sshd_config

# Change
# PermitRootLogin yes
# MaxAuthTries = 6
#to
PermitRootLogin no
MaxAuthTries = 3

# Restart ssh
systemctl reload sshd

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

# install nodejs
yum -y install epel-release
yum -y install nodejs

# install mariadb or postgres
systemctl start mariadb
systemctl enable mariadb

# run mysql secure install script
mysql_secure_installation


