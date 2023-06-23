#!/bin/bash

echo "Welcome back Gib"
echo "Make sure to run this script from the cloned directory without sudo"
read -p "Press enter to continue."
echo 
echo "We will start by adding keyboard shortcuts & personalizing desktop."
echo 

############# SETUP KEYBOARD SHORTCUTS #####################

# Load window management shortcuts
dconf load /org/gnome/desktop/wm/keybindings/ < ./shortcuts/shortcuts-wm.txt

# Load media keys shortcuts
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < ./shortcuts/shortcuts-media.txt

# Load power-related shortcuts
dconf load /org/gnome/settings-daemon/plugins/power/ < ./shortcuts/shortcuts-power.txt

echo "Keyboard shortcuts loaded successfully."

########################## SETUP DESKTOP ###################################
# Add maximize and minimize buttons to windows
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# Set gtk theme to Adwaita-dark 
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Add weekday to clock in top bar 
gsettings set org.gnome.desktop.interface clock-show-weekday true

# Center new windows on screen
gsettings set org.gnome.mutter center-new-windows true

sudo dnf install -y gnome-tweaks

# Copy extensions to extensions directory
mkdir -p ~/.local/share/gnome-shell/extensions
cp -r ./extensions/* ~/.local/share/gnome-shell/extensions
# Open gnome tweaks to allow user to finish personalizing desktop
echo 
echo "Finish changing any settings we couldn't automate." 
echo "Your keyboard shortcuts have been set. Press Ctrl+I to open settings."
echo "You can change any settings in there that could not be automated as well."
echo
gnome-tweaks
read -p "Press enter to continue."

############## UPDATE SYSTEM UPON FRESH FEDORA INSTALL #####################

echo
echo "Updating system..." 
echo
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
echo "Installing RPM Fusion, Microsoft repo & Flatpak..."
echo
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 
sudo dnf groupupdate core -y
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
printf "[vscode]\nname=packages.microsoft.com\nbaseurl=https://packages.microsoft.com/yumrepos/vscode/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscode.repo
#################### INSTALL PACKAGES #########################

echo
echo "Installing necessary packages..."
echo 
sudo dnf install -y neovim xclip emacs git curl wget python3 python3-pip nodejs \
    npm gcc g++ make cmake clang clang-tools-extra clang-analyzer htop neofetch \
    steam lutris kitty powerline powerline-fonts nautilus-python php-fpm composer \
    kernel-devel gh qemu-kvm-core libvirt virt-manager java-latest-openjdk-devel \
    nextcloud-client gparted timeshift jetbrains-mono-fonts-all kmodtool akmods \
    mokutil openssl maven cargo dotnet microsoft-edge-stable code wine

echo 
echo "Packages installed!"
echo 
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
echo "You need to run this to get the java lsp:"
echo "In my experience, you need to install the Oracle JDK for this to work."
echo ":MasonInstall java-language-server@v0.2.32"
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
echo
echo "Running doom sync."
read -p "Press enter to continue."

doom sync

############### COPY NANORC FILE ############################

sudo cp ./nano/nanorc /etc/nanorc

################## INSTALL NVIDIA DRIVERS #########################
echo 
echo "Installing Nvidia Drivers"
echo

sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
echo "Remove the duplicate lines \"rd.driver.blacklist=nouveau, \
    modprobe.blacklist=nouveau, and nvidia-drm.modeset=1\""
kitty -1 -e bash -c "sudo nvim /etc/default/grub"
kitty -1 -e bash -c "sudo nvim /etc/gdm/custom.conf"
read -p "Once complete, close neovim and press enter to continue."
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg 
echo
echo "############## WARNING ################"
echo "Wait 5 minutes before rebooting!"
echo "Nividia drivers MUST finish building!"
echo "############## WARNING ################" 
read -p "Press enter once the drivers have finished building."
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
        ~/Documents/Gib\ Files/Keys+Config\ Files/
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
echo "All done! Now delete this ugly terminal."
echo
