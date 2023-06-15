#!/bin/bash

# Check if running with sudo or as root
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    echo "Please run the script again with sudo."
    exit 1
fi

# Ask user for their username and save as a variable
read -p "Enter your username: " username

# Check if user exists
if ! id -u "$username" >/dev/null 2>&1; then
    echo "User $username does not exist. Please check the username and try again."
    exit 1
fi 

dnf update -y --refresh
clear
echo "Update complete. Beginning script."

# SET UP DNF CONFIG 

echo "Making dnf faster and less bad."
echo "fastestmirror=True" | tee -a /etc/dnf/dnf.conf
echo "max_parallel_downloads=10" | tee -a /etc/dnf/dnf.conf
echo "defaultyes=True" | tee -a /etc/dnf/dnf.conf
echo "keepcache=True" | tee -a /etc/dnf/dnf.conf 

# UPDATE & INSTALL NECESSARY PACKAGES & RPMFUSION

dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm\
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 
dnf groupupdate core -y

dnf install -y nodejs
dnf install -y vim git curl wget python3 python3-pip npm gcc g++\
    make cmake htop neofetch gnome-tweaks xclip neovim emacs

# SET UP POWERLINE WITH BASH

echo "Adding Powerline to bashrc file"
dnf install -y powerline powerline-fonts
# Define the code block to add to .bashrc
code_block="# Powerline configuration\n\
if [ -f /usr/bin/powerline-daemon ]; then\n\
    powerline-daemon -q\n\
    POWERLINE_BASH_CONTINUATION=1\n\
    POWERLINE_BASH_SELECT=1\n\
    source /usr/share/powerline/bash/powerline.sh\n\
fi\n"
# Check if the code block already exists in .bashrc
if grep -qF "$code_block" /home/$username/.bashrc; then
    echo "Powerline config already exists in .bashrc. No changes made."
else
    # Add the code block to .bashrc
    echo -e "$code_block" >> /home/$username/.bashrc
    echo "Powerline config added to .bashrc successfully."
fi

# SET UP KITTY 

echo "Installing and Configuring Kitty"
dnf install -y kitty nautilus-python
# Make kitty config directory if it doesn't exist 
if [ ! -d "/home/$username/.config/kitty" ]; then
    echo "Creating ~/.config/kitty directory"
    mkdir /home/$username/.config/kitty
fi
# Make directory for wallpapers if it doesn't exist 
if [ ! -d "/home/$username/Pictures/Wallpapers/Best_of_the_best" ]; then
    echo "Creating ~/Pictures/Wallpapers/Best_of_the_best directory"
    mkdir -p /home/$username/Pictures/Wallpapers/Best_of_the_best
    chown -R $username:$username /home/$username/Pictures/Wallpapers 
fi

cp ./Wallpapers/* /home/$username/Pictures/Wallpapers/Best_of_the_best/
chown -R $username:$username /home/$username/Pictures/Wallpapers

cp ./kitty/kitty.conf /home/$username/.config/kitty/kitty.conf
chown -R $username:$username /home/$username/.config/kitty
# Make nautilus extension directory if it doesn't exist 
if [ ! -d "/usr/share/nautilus-python/extensions" ]; then
    echo "Creating /usr/share/nautilus-python/extensions directory"
    mkdir -p /usr/share/nautilus-python/extensions
fi
# Add nautilus extension to open kitty from right click menu
cp ./kitty/open_any_terminal_extension.py\
 /usr/share/nautilus-python/extensions/open_any_terminal_extension.py
# While running as root, we will go ahead and add our neovim.desktop file 
# to make neovim use kitty as the terminal.
cp ./nvim/neovim.desktop /usr/share/applications/neovim.desktop

# SET UP EMACS
emacs_path = "$HOME/.emacs.d/bin:$PATH"
# Check if the code block already exists in .bashrc
if grep -qF "$emacs_path" /home/$username/.bashrc; then
    echo "Emacs path already exists in .bashrc. No changes made."
else
    # Add the code block to .bashrc
    echo -e "$code_block" >> /home/$username/.bashrc
    echo "Emacs path added to .bashrc successfully."
fi

# INSTALL NVIDIA DRIVERS 

echo "Updating system & Installing Nvidia Drivers"

dnf install -y kernel-devel
dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
echo "Please wait a good 5 minutes for the drivers to install before rebooting."
echo "In the meantime, make sure your grub file looks good."
echo "Remove the duplicate lines \"rd.driver.blacklist=nouveau, modprobe.blacklist=nouveau, and nvidia-drm.modeset=1\""
kitty -1 -e bash -c "nvim /etc/default/grub"
read -p "Once complete, close neovim and press enter to continue."
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg 
echo "Wait 5 minutes then reboot. Once rebooted, run the script (without sudo) to set up neovim"
