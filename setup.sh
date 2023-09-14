#!/bin/bash

echo "FEDORA SETUP SCRIPT"
echo
echo "Run this script from the cloned directory without sudo."
read - p "Press enter to continue"
echo
echo "Change the root password"
sudo passwd
echo
echo "Importing most of the key bindings"
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
# Install Mouse Cursor themes
tar xvf .tar.gz -C ./gnome_theme/cursor_themes/02-Layan-cursors.tar.xz ~/.local/share/icons
tar xvf .tar.gz -C ./gnome_theme/cursor_themes/material-light-cursors.tar.gz ~/.local/share/icons
tar xvf .tar.gz -C ./gnome_theme/cursor_themes/oreo-blue-cursors.tar.gz ~/.local/share/icons
tar xvf .tar.gz -C ./gnome_theme/cursor_themes/oreo-purple-cursors.tar.gz ~/.local/share/icons
tar xvf .tar.gz -C ./gnome_theme/cursor_themes/oreo-white-cursors.tar.gz ~/.local/share/icons
echo

echo "Changing some settings"
# Add maximize and minimize buttons to windows
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
# Set gtk theme to Adwaita-dark 
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
# Add weekday to clock in top bar 
gsettings set org.gnome.desktop.interface clock-show-weekday true
# Set mouse cursor theme
gsettings set org.gnome.desktop.interface cursor-theme oreo_blue_cursors

echo

echo "Installing gnome-tweaks & Important Flatpaks for Gnome Theme."
sudo dnf install -y gnome-tweaks
flatpak install flathub -y com.mattjakeman.ExtensionManager \
    com.bitwarden.desktop com.github.GradienceTeam.Gradience

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
echo

echo "We will update the system for the first time now."
sudo dnf update -y --refresh

echo "Installing flatpaks in another terminal window."
chmod +x ./scripts/install_flatpaks.sh
./scripts/install_flatpaks.sh &
echo

echo "Installing Apps in apps directory."
chmod +x ./scripts/install_apps.sh &

echo "Installing RPM Fusion, Microsoft repo & Flatpak..."
echo
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 
sudo dnf groupupdate core -y
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
printf "[vscode]\nname=packages.microsoft.com\nbaseurl=https://packages.microsoft.com/yumrepos/vscode/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscode.repo
sudo dnf copr enable atim/heroic-games-launcher -y
echo

echo "Installing necessary packages..."
echo 

sudo dnf install -y ./apps/jdk-20_linux-x64_bin.rpm

sudo dnf groupinstall -y "C Development Tools and Libraries"
sudo dnf groupinstall -y "Development Tools"

sudo dnf install -y neovim xclip emacs git curl wget python3 python3-pip nodejs \
    npm gcc g++ make cmake clang clang-tools-extra clang-analyzer htop neofetch \
    steam lutris kitty powerline powerline-fonts nautilus-python php-fpm composer \
    kernel-devel gh qemu-kvm-core libvirt virt-manager java-latest-openjdk-devel \
    nextcloud-client gparted timeshift jetbrains-mono-fonts-all kmodtool akmods \
    mokutil openssl maven cargo dotnet microsoft-edge-stable code wine go gem \
    luarocks texlive python3-tkinter dnf-plugins-core python3-dnf-plugin-versionlock \
    xkill mangohud airtv dia firewall-config godot scratch texstudio winetricks \
    wireshark seahorse gnome-connections dia dotnet-sdk-7.0 wine-mono adw-gtk_theme \
    heroic-games-launcher-bin python-pygit2 meld nautilus-extensions python-requests \
    python3-gobject 
echo
echo "All DNF packages installed."
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

echo 
echo "Installing Python packages..."
pip install matplotlib numpy appdirs datetime pygame
echo 

echo 
echo "Installing Node packages..."
sudo npm install -g typescript tailwind live-server pm2 create-react-app express \
    mysql2 next nest
echo 

echo "Setting up Neovim..."
sudo cp ./config/nvim/neovim.desktop /usr/share/applications/neovim.desktop
# Make nvim config directory if it doesn't exists
if [ ! -d "~/.config/nvim" ]; then
    echo "Creating ~/.config/nvim directory"
    mkdir ~/.config/nvim
fi
mkdir -p ~/.config/coc/extensions/coc-stylua-data
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

echo "Replacing Nanorc file."
sudo cp ./config/nanorc /etc/nanorc
echo

echo "Setting up Git/GitHub..."
git config --global user.name "gibbyb"
git config --global user.email "gib@gibbyb.com"
git config --global core.editor "nvim"
git config --global init.defaultBranch "main"
gh auth login
echo

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
    nvidia-resume.service
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
echo "All done! Now delete this ugly terminal."
echo
