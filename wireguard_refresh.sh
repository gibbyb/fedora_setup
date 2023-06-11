#!/bin/bash

# Generate SSH key pair if not already generated
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa 
fi

echo "Make sure you have access to the server. We will be copying the public key to the server."
read -p "Press enter to continue."

# Copy public key to remote server
ssh-copy-id gib@gibbyb.com

# Remove existing directory
rm -r ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard

# Create a new directory
mkdir Wireguard

# Copy files from remote server
scp -r gib@gibbyb.com:~/Documents/Wireguard ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard 

# Rename directories and files
mv ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/peer1 ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop
mv ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/peer2 ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-iphone
mv ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop/peer1.conf ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop/Home.conf

# Delete existing network connection
sudo nmcli connection delete Home

# Import wireguard connection
sudo nmcli connection import type wireguard file ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop/Home.conf

