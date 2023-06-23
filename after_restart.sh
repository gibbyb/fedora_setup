#!/bin/bash

echo
echo "Enrolling Key to MOK"
echo
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
echo
echo "Enroll the key once you reboot."
echo

