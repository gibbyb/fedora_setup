#!/bin/bash

sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)

sudo usermod -aG nordvpn $USER 

echo "Please log out and log back in to use NordVPN"
echo
echo "To login, run 'nordvpn login' then open the link and log in. Once logged in, copy the URL and run this command:"
echo "nordvpn login --callback \"nordvpn://copied_url\""
