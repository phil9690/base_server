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

