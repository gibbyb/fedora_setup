#!/bin/bash

echo "FEDORA SETUP SCRIPT"
echo
echo "Run this script from the cloned directory without sudo."
echo "It is also suggested to run the install_packages and install_flatpaks sripts before you run this script."
echo "Those can take quite a while so it is better to separate them and run them first."
echo
read - p "Press enter to continue"
echo
read -p "Do you want to change the root password? I would recommend not doing this. (y/n) " answer_root_passwd
echo
if [ "$answer_root_passwd" == "y" ]; then
    echo "Change your root password..."
    sudo passwd
fi

read -p "Name of Computer (Hostname): " hostname_response
sudo hostnamectl set-hostname $hostname_response

echo
echo "Importing key bindings..."
echo
# WM keybindings
dconf load /org/gnome/desktop/wm/keybindings/ < ./gnome_theme/shortcuts/shortcuts-wm.txt
# Media keybindings
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < ./gnome_theme/shortcuts/shortcuts-media.txt
# Mutter keybindings
dconf load /org/gnome/mutter/keybindings/ < ./gnome_theme/shortcuts/shortcuts-mutter.txt
# Power settings
dconf load /org/gnome/settings-daemon/plugins/power/ < ./gnome_theme/shortcuts/shortcuts-power.txt
# Shell keybindings
dconf load /org/gnome/shell/keybindings/ < ./gnome_theme/shortcuts/shortcuts-shell.txt
# Wayland keybindings
dconf load /org/gnome/mutter/wayland/keybindings/ < ./gnome_theme/shortcuts/shortcuts-wayland.txt
echo
echo "Installing mouse cursor themes..."
mkdir -p ~/.local/share/icons
tar xvf ./gnome_theme/cursor_themes/02-Layan-cursors.tar.xz -C ~/.local/share/icons
tar xvf ./gnome_theme/cursor_themes/material-light-cursors.tar.gz -C ~/.local/share/icons
tar xvf ./gnome_theme/cursor_themes/oreo-blue-cursors.tar.gz -C ~/.local/share/icons
tar xvf ./gnome_theme/cursor_themes/oreo-purple-cursors.tar.gz -C ~/.local/share/icons
tar xvf ./gnome_theme/cursor_themes/oreo-white-cursors.tar.gz -C ~/.local/share/icons
echo


echo "Changing some Gnome settings..."
# Add maximize and minimize buttons to windows
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
# Set gtk theme to Adwaita-dark 
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
# Add weekday to clock in top bar 
gsettings set org.gnome.desktop.interface clock-show-weekday true
# Set mouse cursor theme
gsettings set org.gnome.desktop.interface cursor-theme oreo_blue_cursors
# Set timeout time to 30 seconds to get rid of the annoying pop up.
gsettings set org.gnome.mutter check-alive-timeout 30000
# Enable fractional scaling
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
echo

echo "Installing gnome-tweaks & Important Flatpaks for Gnome Theme."
sudo dnf install -y gnome-tweaks
flatpak install flathub -y com.mattjakeman.ExtensionManager \
    com.bitwarden.desktop com.github.GradienceTeam.Gradience \
    org.gtk.Gtk3theme.adw-gtk3-dark 

echo
echo "Copying extensions..." 
echo "You will be able to enable them in Extension Manager after reboot."
mkdir -p ~/.local/share/gnome-shell/extensions
cp -r ./gnome_extensions/* ~/.local/share/gnome-shell/extensions
echo

echo "Finish changing any other settings in Gnome Tweaks & Gnome Settings."
echo "You will need to add/remove some more shortcuts manually."
gnome-tweaks
gnome-control-center
echo

echo "Making DNF better..."
sudo echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
sudo echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
sudo echo "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf
sudo echo "keepcache=True" | sudo tee -a /etc/dnf/dnf.conf
sudo echo "deltarpm=True" | sudo tee -a /etc/dnf/dnf.conf
echo
echo
read -p "If you have not yet run the install_packages and install_flatpaks scripts, do so now. Once they have run, press enter." 
echo
echo
echo "Replacing .bashrc file."
cp ./config/.bashrc ~/.bashrc
source ~/.bashrc
echo

echo "Setting up Kitty Terminal..."
# Make kitty config directory if it doesn't exist 
if [ ! -d "~/.config/kitty" ]; then
    echo "Creating ~/.config/kitty directory"
    mkdir ~/.config/kitty
fi

# Copy needed wallpapers and kitty config file
mkdir -p ~/Pictures/Wallpapers/Best_of_the_best
cp ./Wallpapers/* ~/Pictures/Wallpapers/Best_of_the_best/
cp ./config/kitty/kitty.conf ~/.config/kitty/kitty.conf

# Copy JetBrains Mono Nerd Font to fonts folder
sudo mv ./config/kitty/JetBrainsMono /usr/share/fonts/JetBrainsMono

# Make nautilus extension directory if it doesn't exist 
if [ ! -d "/usr/share/nautilus-python/extensions" ]; then
    echo "Creating /usr/share/nautilus-python/extensions directory"
    sudo mkdir -p /usr/share/nautilus-python/extensions
fi

# Add nautilus extension to open kitty from right click menu
sudo cp ./config/kitty/open_any_terminal_extension.py \
    /usr/share/nautilus-python/extensions/open_any_terminal_extension.py
git clone https://gitlab.gnome.org/philippun1/turtle ~/Downloads/turtle
cd ~/Downloads/turtle
python install.py install --user
pip3 install . --user
nautilus -q
nautilus --no-desktop
cd ~/Downloads/fedora_setup

echo "Setting up Neovim..."
sudo cp ./config/nvim/neovim.desktop /usr/share/applications/neovim.desktop
# Make nvim config directory if it doesn't exists
if [ ! -d "~/.config/nvim" ]; then
    echo "Creating ~/.config/nvim directory"
    mkdir ~/.config/nvim
fi
echo "Copying init.lua, & lua directory to ~/.config/nvim"
cp ./config/nvim/init.lua ~/.config/nvim/init.lua
mkdir -p ~/.config/nvim/lua/gib_nvim
mkdir -p ~/.config/nvim/after/plugin
cp ./config/nvim/lua/gib_nvim/* ~/.config/nvim/lua/gib_nvim/
# Install packer.nvim 
echo "Installing packer.nvim"
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim
echo
echo "Opening packer.lua. Source the file and run \":PackerSync\""
echo "to install all plugins."
echo
echo "Once complete, close the window."
kitty -1 -e bash -c "nvim ~/.config/nvim/lua/gib_nvim/packer.lua"
read -p "Press enter to continue."
echo echo "Copying after directory to ~/.config/nvim" 
cp ./config/nvim/after/plugin/* ~/.config/nvim/after/plugin/ 
echo
echo "Opening neovim. Run \":Copilot setup\" to setup GitHub Copilot."
echo ":MasonInstall java-language-server@v0.2.32 installs the only working Java LSP."
echo
echo "Once complete, close the window."
echo
kitty -1 -e "nvim"
git config --global core.editor "nvim"
echo "Neovim setup complete."
echo

echo "Setting up Ranger..."
echo
mkdir ~/.config/ranger
cp ./config/ranger/* ~/.config/ranger/

echo "Replacing Nanorc file."
sudo cp ./config/nano/nanorc /etc/nanorc
echo

echo "Setting up Git/GitHub..."
git config --global user.name "gibbyb"
git config --global user.email "gib@gibbyb.com"
git config --global core.editor "nvim"
git config --global init.defaultBranch "main"
gh auth login
echo

echo "Setting up Lobster"
sudo curl -sL github.com/justchokingaround/lobster/raw/main/lobster.sh -o \
    /usr/local/bin/lobster && sudo chmod +x /usr/local/bin/lobster
cp ./config/lobster/lobster_config.txt ~/.config/lobster/lobster_config.txt
echo
read -p "Would you like to install NVIDIA Drivers? (y/n) " answer_nvidia
if [ "$answer_nvidia" == "y" ]; then
    echo "Installing NVIDIA Drivers..."
    echo
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
    echo
    echo "Remove the duplicate lines \"rd.driver.blacklist=nouveau, \
        modprobe.blacklist=nouveau, and nvidia-drm.modeset=1\""
    echo
    kitty -1 -e bash -c "sudo nvim /etc/default/grub"
    # kitty -1 -e bash -c "sudo nvim /etc/gdm/custom.conf"
    read -p "Once complete, close neovim and press enter to continue."
    sudo grub2-mkconfig -o /etc/grub2-efi.cfg 
    echo
    echo "############## WARNING ################"
    echo "Wait 5 minutes before rebooting!"
    echo "Nividia drivers MUST finish building!"
    echo "############## WARNING ################" 
    read -p "Press enter once the drivers have finished building."
    echo
    echo "Enabling Nvidia system services"
    sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service \
        nvidia-resume.service nvidia-powerd.service
fi
echo
read -p "Do you want to disable Wayland? (y/n) " answer_wayland
if [ "$answer_wayland" == "y" ]; then
    echo "Disabling Wayland"
    sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' \
        /etc/gdm/custom.conf
    echo "Enabling VNCServer service..."
    sudo systemctl enable --now vncserver-x11-serviced.service
fi
echo
echo 
read -p "Should we set up asusctl (Is this your laptop?) (y/n) " roganswer
if [ "$roganswer" == "y" ]; then
    sudo dnf copr enable lukenukem/asus-linux
    sudo dnf update
    sudo dnf install asusctl supergfxctl
    sudo dnf update --refresh
    sudo systemctl enable --now supergfxd.service
    sudo dnf install asusctl-rog-gui
fi
echo

echo
echo "Enrolling Key to MOK"
echo
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
echo
echo "Enroll the key once you reboot."
echo
echo "Enabling Libvirt service now." 
sudo systemctl enable --now libvirtd.service

echo "Setting up Wireguard VPN..."
echo "You will need to SSH to your server to copy the files."
echo "So ensure that you can connect to your server, or configure yourself."
echo "Either way, make sure to change DNS and change it to not autoconnect."
read -p "Would you like to set up your Wireguard VPN? (y/n) " answer

if [ "$answer" == "y" ]; then
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
echo "Installing Grub-Btrfs..."
git clone https://github.com/Antynea/grub-btrfs
mv ./config/grub-btrfs/config ./grub-btrfs/config
cd ./grub-btrfs
sudo dnf install -y inotify-tools
sudo make install
sudo grub2-mkconfig -o /etc/grub2-efi.cfg
sudo systemctl enable --now grub-btrfsd
echo
echo "Replace \"ExecStart=/usr/bin/grub-btrfsd /.snapshots --syslog\""
echo "with \"ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto\""
echo
read -p "Copy the line and press enter to continue."
echo
sudo systemctl edit --full grub-btrfsd
echo
echo "Save the file and close the window then press enter to continue."
echo
sudo systemctl restart grub-btrfsd
echo
echo "We're going to get rid of the ugly ass Nextcloud Folders in Sidebar of Nautilus"
echo
sudo rm /usr/share/cloud-providers/com.nextcloudgmbh.Nextcloud.ini
echo "You need to remove the following lines from the .desktop file."
echo
echo "-Implements=org.freedesktop.CloudProviders"
echo
echo "[org.freedesktop.CloudProviders]"
echo "-BusName=com.nextcloudgmbh.Nextcloud"
echo "ObjectPath=/com/nextcloudgmbh/Nextcloud"
read -p "Press enter to continue."
kitty -1 -e bash -c "sudoedit /usr/share/applications/com.nextcloud.desktopclient.nextcloud.desktop"

echo "All done! Reboot and enjoy!"
echo
