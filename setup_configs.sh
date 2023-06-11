#!/bin/bash

# Check if running with sudo or as root
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    echo "Please run the script again with sudo."
    exit 1
fi

# UPDATE & INSTALL NECESSARY PACKAGES & RPMFUSION

dnf update -y --refresh
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-\$(rpm -E %fedora).noarch.rpm\
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y vim git curl wget python3 python3-pip npm gcc g++\
    make cmake htop neofetch kernel-devel zsh
dnf groupupdate core -y

# SET UP DNF CONFIG 

echo "Making dnf faster and less bad."
echo "fastestmirror=True" | tee -a /etc/dnf/dnf.conf
echo "max_parallel_downloads=10" | tee -a /etc/dnf/dnf.conf
echo "defaultyes=True" | tee -a /etc/dnf/dnf.conf
echo "keepcache=True" | tee -a /etc/dnf/dnf.conf

# DISABLE WAYLAND

echo "Disabling Wayland" 
sed -i 's/^#WaylandEnable=false/WaylandEnable=false/' /etc/gdm/custom.conf

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
if grep -qF "$code_block" ~/.bashrc; then
    echo "Code block already exists in .bashrc. No changes made."
else
    # Add the code block to .bashrc
    echo -e "$code_block" >> ~/.bashrc
    echo "Code block added to .bashrc successfully."
fi


# SET UP KITTY 

echo "Installing and Configuring Kitty"
dnf install -y kitty nautilus-python
# Make kitty config directory if it doesn't exist 
if [ ! -d "~/.config/kitty" ]; then
    echo "Creating ~/.config/kitty directory"
    mkdir ~/.config/kitty
fi
cp -r ./Wallpapers ~/Pictures/Wallpapers/Best_of_the_best
cp ./kitty/kitty.conf ~/.config/kitty/kitty.conf
# Make nautilus extension directory if it doesn't exist 
if [ ! -d "/usr/share/nautilus-python/extensions" ]; then
    if [ ! -d "/usr/share/nautilus-python" ]; then
        echo "Creating /usr/share/nautilus-python directory"
        mkdir /usr/share/nautilus-python
    fi
    echo "Creating /usr/share/nautilus-python/extensions directory"
    mkdir /usr/share/nautilus-python/extensions
fi
# Add nautilus extension to open kitty from right click menu
cp ./kitty/open_any_terminal_extension.py\
/usr/share/nautilus-python/extensions/open_any_terminal_extension.py 

# SET UP NEOVIM

echo "Installing and Configuring Neovim"
dnf install -y neovim 
# Make nvim config directory if it doesn't exists
if [ ! -d "~/.config/nvim" ]; then
    echo "Creating ~/.config/nvim directory"
    mkdir ~/.config/nvim
fi
echo "Copying init.lua and lua directory to ~/.config/nvim"
cp ./nvim/init.lua ~/.config/nvim/init.lua
cp -r ./nvim/lua ~/.config/nvim/lua
# Install packer.nvim 
echo "Installing packer.nvim"
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
echo "Opening packer.lua. Source the file and run \":PackerSync\""
kitty -1 -e "nvim ~/.config/nvim/lua/packer.lua"
read -p "Once complete, close window & press enter to continue."
echo "Copying after directory to ~/.config/nvim"
cp -r ./nvim/after ~/.config/nvim/after
echo "Opening neovim. Run \":Mason\" and install the extensions you want."
echo "You can also run \":Copilot setup\" to setup GitHub Copilot."
kitty -1 -e "nvim"
read -p "Once complete, close neovim and press enter to continue."

# INSTALL NVIDIA DRIVERS

dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
echo "Please wait a good 5 minutes for the drivers to install before rebooting."
echo "In the meantime, make sure your grub file looks good."
echo "Remove the duplicate lines \"rd.driver.blacklist=nouveau, modprobe.blacklist=nouveau, and nvidia-drm.modeset=1\""
kitty -1 -e "nvim /etc/default/grub"
read -p "Once complete, close neovim and press enter to continue."
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg 

# SET WALLPAPERS 

gsettings set org.gnome.desktop.background picture-uri file:///home/gib/Pictures/Wallpapers/Best_of_the_best/gloomyroadcatbg.png


