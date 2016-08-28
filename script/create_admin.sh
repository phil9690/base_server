# Create user
echo "******INITIAL SERVER SETUP******"
echo "******ADMIN USER CREATION*******"
echo "Type the admin username"
read user

adduser $user

# Set user password
echo "Set the password for $user"
passwd

# Give user admin privildges
gpasswd -a $user wheel

# Copy this script to the new user to continue
cp ~/base_server /home/$user

echo "Logging in to $user..."
echo "After you have been prompted for your password run the following command:"
echo "~/base_server/script/server_setup.sh"

# Switch to new user
su - $user

