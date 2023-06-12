#!/bin/bash

# Remove existing directory
rm -r ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard

# Copy files from remote server
scp -r gib@gibbyb.com:~/Documents/Wireguard ~/Documents/Gib\ Files/Keys+Config\ Files

# Rename directories and files
mv ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/peer1 ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop
mv ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/peer2 ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-iphone
mv ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop/peer1.conf ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop/Home.conf

# Delete existing network connection
sudo nmcli connection delete Home

# Import wireguard connection
sudo nmcli connection import type wireguard file ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop/Home.conf

