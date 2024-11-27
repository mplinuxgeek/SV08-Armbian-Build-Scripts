#!/bin/bash
set -euo pipefail

# Set user credentials
USERNAME="sovol"
PASSWORD="sovol"

# Create the user and set the password
useradd -m -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd
echo "root:$PASSWORD" | chpasswd

# Add user to required groups
usermod -aG tty,dialout,sudo "$USERNAME"

# Remove default login prompt and set hostname
rm -f /root/.not_logged_in_yet
hostname -b "sv08"

# Add NOPASSWD entry for the sovol user in sudoers
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/010_$USERNAME

# Update and install necessary packages
apt-get update
apt-get upgrade -y
apt-get install -y git

# Ensure the installer script is executable, then run it as the sovol user
su - "$USERNAME" -c "/tmp/overlay/installer.sh"

# Ensure the destination directory for configuration exists
mkdir -p /home/"$USERNAME"/printer_data/config

# Copy files from /tmp/overlay
cp -rfv /tmp/overlay/config/* /home/"$USERNAME"/printer_data/config/
cp -rfv /tmp/overlay/plugins/* /home/"$USERNAME"/klipper/klippy/extras/

# Copy and set executable permissions for scripts in /usr/local/bin
if [[ -d "/tmp/overlay/scripts" ]]; then
    for script in /tmp/overlay/scripts/*; do
        cp -v "$script" /usr/local/bin/
        chmod -v +x "/usr/local/bin/$(basename "$script")"
    done
fi

# Copy and set executable permissions for scripts in the user's home directory
if [[ -d "/tmp/overlay/home" ]]; then
    for script in /tmp/overlay/home/*; do
        cp -v "$script" "/home/$USERNAME/"
        chmod -v +x "/home/$USERNAME/$(basename "$script")"
    done
fi

if compgen -G "/tmp/overlay/custom_config/*" > /dev/null; then
    cp -rfv /tmp/overlay/custom_config/* /home/"$USERNAME"/printer_data/config/
fi

# Adjust ownership of the copied files to the sovol user
chown -Rv "$USERNAME":"$USERNAME" /home/"$USERNAME"/ | grep -v retained

# Run the systemd setup script explicitly with bash
bash /tmp/overlay/setup_systemd_scripts.sh

sed -i '/^disp_mode=/s/^/#/' /boot/armbianEnv.txt