#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Update the package list
apt update

# Install XFCE desktop environment
kali-desktop-xfce  -o dpkg::options::="--force-overwrite"


# Add Kali Linux repository
if ! grep -q "kali" /etc/apt/sources.list; then
    echo "Adding Kali Linux repositories."
    cat <<EOF >> /etc/apt/sources.list

deb http://http.kali.org/kali kali-rolling main non-free contrib
EOF
else
    echo "Kali Linux repository already exists."
fi

# Add Kali's GPG key
wget -q -O - https://archive.kali.org/archive-key.asc | apt-key add -

# Update the package list again with Kali repository
apt update

# Install full Kali Linux with XFCE desktop
apt install -y kali-defaults kali-desktop-xfce kali-themes kali-wallpapers xfce4-terminal

# Set XFCE as the default desktop environment
update-alternatives --set x-session-manager /usr/bin/startxfce4

# Clean up
apt autoremove -y
apt clean

# Inform the user
echo "Full Kali Linux with XFCE desktop environment has been installed on Debian. You can now log out and select XFCE from the login screen."
