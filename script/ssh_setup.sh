# Set up ssh keys
# Make ssh directory for user
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

# NEED TO PUT THE SSH KEY IN THE FILE

# Restrict authorized keys file
chmod 600 .ssh/authorized_keys

# Return to root user
exit

# NEED TO RUN ssh_configuration.sh   after this
