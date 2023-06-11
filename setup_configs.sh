#!/bin/bash

# Check if running with sudo or as root
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    echo "Please run the script again with sudo."
    exit 1
fi

# Function to check if a user exists
user_exists() {
    if id "$1" >/dev/null 2>&1; then
        return 0 # User exists
    else
        return 1 # User does not exist
    fi
}

# Ask user for their username and validate
read -p "Enter your username: " username
if ! user_exists "$username"; then
    echo "User '$username' does not exist on the system."
    exit 1
fi

# UPDATE & INSTALL NECESSARY PACKAGES & RPMFUSION

sudo -u "$username" dnf update -y --refresh
sudo -u "$username" dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo -u "$username" dnf install -y vim git curl wget python3 python3-pip npm gcc g++ \
    make cmake htop neofetch kernel-devel zsh gnome-tweaks
sudo -u "$username" dnf groupupdate core -y

# SET UP DNF CONFIG

echo "Making dnf faster and less bad."
echo "fastestmirror=True" | sudo -u "$username" tee -a /etc/dnf/dnf.conf
echo "max_parallel_downloads=10" | sudo -u "$username" tee -a /etc/dnf/dnf.conf
echo "defaultyes=True" | sudo -u "$username" tee -a /etc/dnf/dnf.conf
echo "keepcache=True" | sudo -u "$username" tee -a /etc/dnf/dnf.conf

# DISABLE WAYLAND

echo "Disabling Wayland"
sudo -u "$username" sed -i 's/^#WaylandEnable=false/WaylandEnable=false/' /etc/gdm/custom.conf

# SET UP POWERLINE WITH BASH

echo "Adding Powerline to bashrc file"
sudo -u "$username" dnf install -y powerline powerline-fonts
# Define the code block to add to .bashrc
code_block="# Powerline configuration\n\
if [ -f /usr/bin/powerline-daemon ]; then\n\
    powerline-daemon -q\n\
    POWERLINE_BASH_CONTINUATION=1\n\
    POWERLINE_BASH_SELECT=1\n\
    source /usr/share/powerline/bash/powerline.sh\n\
fi\n"
# Check if the code block already exists in .bashrc
if sudo -u "$username" grep -qF "$code_block" /home/$username/.bashrc; then
    echo "Code block already exists in .bashrc. No changes made."
else
    # Add the code block to .bashrc
    sudo -u "$username" bash -c "echo -e '$code_block' >> /home/$username/.bashrc"
    echo "Code block added to .bashrc successfully."
fi

# SET UP KITTY

echo "Installing and Configuring Kitty"
sudo -u "$username" dnf install -y kitty nautilus-python
# Make kitty config directory if it doesn't exist
if [ ! -d "/home/$username/.config/kitty" ]; then
    echo "Creating ~/.config/kitty directory"
    sudo -u "$username" mkdir /home/$username/.config/kitty
fi
sudo -u "$username" cp -r ./Wallpapers /home/$username/Pictures/Wallpapers/Best_of_the_best
sudo -u "$username" cp ./kitty/kitty.conf /home/$username/.config/kitty/kitty.conf
# Make nautilus extension directory if it doesn't exist
if [ ! -d "/usr/share/nautilus-python/extensions" ]; then
    if [ ! -d "/usr/share/nautilus-python" ]; then
        echo "Creating /usr/share/nautilus-python directory"
        sudo -u "$username" mkdir /usr/share/nautilus-python
    fi
    echo "Creating /usr/share/nautilus-python/extensions directory"
    sudo -u "$username" mkdir /usr/share/nautilus-python/extensions
fi
# Add nautilus extension to open kitty from right click menu
sudo -u "$username" cp ./kitty/open_any_terminal_extension.py \
    /usr/share/nautilus-python/extensions/open_any_terminal_extension.py

# SET UP NEOVIM

echo "Installing and Configuring Neovim"
sudo -u "$username" dnf install -y neovim
# Make nvim config directory if it doesn't exist
if [ ! -d "/home/$username/.config/nvim" ]; then
    echo "Creating ~/.config/nvim directory"
    sudo -u "$username" mkdir /home/$username/.config/nvim
fi
echo "Copying init.lua and lua directory to ~/.config/nvim"
sudo -u "$username" cp ./nvim/init.lua /home/$username/.config/nvim/init.lua
sudo -u "$username" cp -r ./nvim/lua /home/$username/.config/nvim/lua
# Install packer.nvim
echo "Installing packer.nvim"
sudo -u "$username" git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    /home/$username/.local/share/nvim/site/pack/packer/start/packer.nvim
echo "Opening packer.lua. Source the file and run \":PackerSync\""
sudo -u "$username" kitty -1 -e "nvim ~/.config/nvim/lua/packer.lua"
read -p "Once complete, close the window & press Enter to continue."
echo "Copying after directory to ~/.config/nvim"
sudo -u "$username" cp -r ./nvim/after /home/$username/.config/nvim/after
echo "Opening neovim. Run \":Mason\" and install the extensions you want."
echo "You can also run \":Copilot setup\" to set up GitHub Copilot."
sudo -u "$username" kitty -1 -e "nvim"
read -p "Once complete, close neovim and press Enter to continue."

# INSTALL NVIDIA DRIVERS

sudo -u "$username" dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
echo "Please wait for a few minutes for the drivers to install before rebooting."
echo "In the meantime, make sure your grub file looks good."
echo "Remove the duplicate lines \"rd.driver.blacklist=nouveau, modprobe.blacklist=nouveau, and nvidia-drm.modeset=1\""
sudo -u "$username" kitty -1 -e "nvim /etc/default/grub"
read -p "Once complete, close neovim and press Enter to continue."
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

# SET WALLPAPERS

sudo -u "$username" gsettings set org.gnome.desktop.background picture-uri file:///home/$username/Pictures/Wallpapers/Best_of_the_best/gloomyroadcatbg.png

