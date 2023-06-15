#!/bin/bash

echo "Welcome back Gib"
echo "Make sure to run this script from the cloned directory without sudo"
read -p "Press enter to continue."
echo 
echo "We will start by adding keyboard shortcuts & updating the system."
echo 

############# SETUP KEYBOARD SHORTCUTS #####################
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < shortcuts.txt

############## UPDATE SYSTEM UPON FRESH FEDORA INSTALL #####################

sudo dnf update -y --refresh
echo 
echo "Updates complete. Before we install any more packages, let's fix DNF."
echo

#################### FIX DNF #########################


sudo echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
sudo echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
sudo echo "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf
sudo echo "keepcache=True" | sudo tee -a /etc/dnf/dnf.conf

#################### INSTALL RPM FUSION #########################


echo 
echo "Installing RPM Fusion & Flatpak..."
echo
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 
sudo dnf groupupdate core -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#################### INSTALL PACKAGES #########################

echo
echo "Installing necessary packages..."
echo 
sudo dnf install -y neovim xclip emacs git curl wget python3 python3-pip nodejs \
    npm gcc g++ make cmake clang clang-tools-extra clang-analyzer htop neofetch \
    gnome-tweaks steam lutris kitty powerline powerline-fonts nautilus-python \
    kernel-devel gh qemu-kvm-core libvirt virt-manager java-latest-openjdk-devel \
    nextcloud-client gparted timeshift

echo 
echo "Packages installed!"
echo 

#################### INSTALL FLATPAK PACKAGES #########################

echo
echo "Installing Flatpak packages..."
echo
flatpak install flathub -y com.microsoft.Edge sh.cider.Cider \
    com.discordapp.Discord com.obsproject.Studio com.mojang.Minecraft \
    org.libreoffice.LibreOffice org.yuzu_emu.yuzu \
    com.mattjakeman.ExtensionManager org.gnome.gThumb org.gnome.Geary \
    org.gimp.GIMP org.kde.kdenlive com.slack.Slack com.github.xournalpp.xournalpp \
    de.haeckerfelix.Fragments com.visualstudio.code com.prusa3d.PrusaSlicer \
    org.freecadweb.FreeCAD org.videolan.VLC com.bitwarden.desktop \
    com.github.PintaProject.Pinta com.heroicgameslauncher.hgl


#################### REMOVE PACKAGES WE DO NOT WANT #########################

echo 
echo "Removing packages..."
echo
sudo dnf remove -y gnome-boxes gnome-connections gnome-contacts simple-scan \
    mediawriter gnome-tour eog gnome-photos libreoffice-calc libreoffice-writer \
    libreoffice-impress totem gnome-text-editor gnome-maps

#################### SET UP POWERLINE WITH BASH #########################

echo 
echo "Adding Powerline to bashrc file..."
echo

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
    echo "Powerline config already exists in .bashrc. No changes made."
else
    # Add the code block to .bashrc
    echo -e "$code_block" >> ~/.bashrc
    echo "Powerline config added to .bashrc successfully."
    echo
fi
echo

######################### SET UP KITTY ################################

echo
echo "Now we will set up Kitty"
echo 

# Make kitty config directory if it doesn't exist 
if [ ! -d "~/.config/kitty" ]; then
    echo "Creating ~/.config/kitty directory"
    mkdir ~/.config/kitty
fi

# Copy needed wallpapers and kitty config file
mkdir -p ~/Pictures/Wallpapers/Best_of_the_best
cp ./Wallpapers/* ~/Pictures/Wallpapers/Best_of_the_best/
cp ./kitty/kitty.conf ~/.config/kitty/kitty.conf

# Make nautilus extension directory if it doesn't exist 
if [ ! -d "/usr/share/nautilus-python/extensions" ]; then
    echo "Creating /usr/share/nautilus-python/extensions directory"
    sudo mkdir -p /usr/share/nautilus-python/extensions
fi

# Add nautilus extension to open kitty from right click menu
sudo cp ./kitty/open_any_terminal_extension.py \
    /usr/share/nautilus-python/extensions/open_any_terminal_extension.py
nautilus -q

########################## SET UP NEOVIM ################################

echo
echo "Now we will set up Neovim"
echo

sudo cp ./nvim/neovim.desktop /usr/share/applications/neovim.desktop

# Make nvim config directory if it doesn't exists
if [ ! -d "~/.config/nvim" ]; then
    echo "Creating ~/.config/nvim directory"
    mkdir ~/.config/nvim
fi

echo "Copying init.lua and lua directory to ~/.config/nvim"
cp ./nvim/init.lua ~/.config/nvim/init.lua
mkdir -p ~/.config/nvim/lua/gib_nvim
mkdir -p ~/.config/nvim/after/plugin
cp ./nvim/lua/gib_nvim/* ~/.config/nvim/lua/gib_nvim/

# Install packer.nvim 
echo "Installing packer.nvim"
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo "Opening packer.lua. Source the file and run \":PackerSync\""
echo "Once complete, close the window."
kitty -1 -e bash -c "nvim ~/.config/nvim/lua/gib_nvim/packer.lua"
read -p "Press enter to continue."

echo "Copying after directory to ~/.config/nvim"
cp ./nvim/after/plugin/* ~/.config/nvim/after/plugin/ 
echo "Opening neovim. Run \":Mason\" and install the extensions you want."
echo "You can also run \":Copilot setup\" to setup GitHub Copilot."
echo "Once complete, close the window."
kitty -1 -e "nvim"
git config --global core.editor "nvim"
echo "Neovim setup complete."

######################### SET UP EMACS ################################

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install

emacs_path="#Emacs path\n \
    export PATH=\"\$HOME/.config/emacs/bin:\$PATH\"\n \
    alias emacs=\"emacsclient -c -a 'emacs'\""

# Check if the code block already exists in .bashrc
if grep -qF "$emacs_path" ~/.bashrc; then
    echo "Emacs path already exists in .bashrc. No changes made."
else
    # Add the code block to .bashrc
    echo -e "$emacs_path" >> ~/.bashrc
    echo "Emacs path added to .bashrc successfully."
fi
source ~/.bashrc

sudo cp ./emacs/emacs_daemon.desktop /usr/share/applications/emacs_daemon.desktop
sudo cp ./emacs/emacs_client.desktop /usr/share/applications/emacs_client.desktop

echo "About to run the doom sync command. If the command isn't recognized,"
echo "then there is an issue with how the bashrc file was edited."
echo "If this is the case, fix it and then remove this message from the script."
read -p "Press enter to continue."

doom sync

################## INSTALL NVIDIA DRIVERS #########################
echo 
echo "Installing Nvidia Drivers"
echo

sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
echo "Remove the duplicate lines \"rd.driver.blacklist=nouveau, \
    modprobe.blacklist=nouveau, and nvidia-drm.modeset=1\""
read -p "Once complete, close neovim and press enter to continue."
kitty -1 -e bash -c "nvim /etc/default/grub"
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg 
echo
echo "############## WARNING ################"
echo "Wait 5 minutes before rebooting!"
echo "Nividia drivers MUST finish building!"
echo "############## WARNING ################"
echo
echo "Enabling Nvidia system services"
sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service \
    nvidia-resume.service

################## SET UP WIREGUARD #########################

read -p "Would you like to set up your Wireguard VPN? (y/n) " answer

if [ "$answer" == "y" ]; then
    read -p "Make sure you can SSH to your server. Press enter to continue."
    mkdir -p ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard
    # Copy files from remote server
    scp -r gib@gibbyb.com:~/Documents/Wireguard \
        ~/Documents/Gib\ Files/Keys+Config\ Files
    # Rename directories and files
    mv ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/peer1 \
        ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop
    mv ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/peer2 \
        ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-iphone
    mv ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop/peer1.conf \
        ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop/Home.conf

    # Import wireguard connection
    sudo nmcli connection import type wireguard file \
        ~/Documents/Gib\ Files/Keys+Config\ Files/Wireguard/gib-laptop/Home.conf
fi
echo
echo "All done! Now delete this shitty terminal."
echo
