#!/bin/bash
sudo dnf downgrade ostree-libs
sudo dnf install python3-dnf-plugin-versionlock

sudo dnf versionlock add ostree-libs
# sudo dnf versionlock delete ostree-libs
