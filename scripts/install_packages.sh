#!/bin/bash
echo
echo "Updating system for the first time. This may take a while."
echo
sudo dnf update -y --refresh
echo
echo "Installing DNF Packages."
echo
echo "Installing RPM Fusion, Microsoft repo & Flatpak..."
echo
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 
sudo dnf groupupdate core -y
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
printf "[vscode]\nname=packages.microsoft.com\nbaseurl=https://packages.microsoft.com/yumrepos/vscode/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscode.repo
sudo dnf copr enable atim/heroic-games-launcher -y
sudo dnf config-manager --add-repo https://repo.vivaldi.com/stable/vivaldi-fedora.repo
echo
echo "Installing necessary packages..."
echo 
sudo dnf install -y ../apps/jdk-21_linux-x64_bin.rpm
ssudo dnf groupinstall -y "C Development Tools and Libraries"udo dnf groupinstall -y "C Development Tools and Libraries"
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y neovim xclip git curl wget python3 python3-pip nodejs \
    npm gcc g++ make cmake clang clang-tools-extra clang-analyzer htop neofetch \
    steam lutris kitty powerline powerline-fonts nautilus-python php-fpm composer \
    kernel-devel gh qemu-kvm-core libvirt virt-manager java-latest-openjdk-devel \
    nextcloud-client timeshift jetbrains-mono-fonts-all kmodtool akmods \
    mokutil openssl maven cargo dotnet-sdk-8.0 code wine go gem \
    luarocks python3-tkinter dnf-plugins-core python3-dnf-plugin-versionlock \
    mangohud firewall-config godot scratch winetricks wireshark seahorse \
    gnome-connections dotnet-sdk-7.0 wine-mono fzf mpv python-pygit2 meld \
    heroic-games-launcher-bin nautilus-extensions python-requests python3-gobject \
    gnome-text-editor gnome-network-displays regextester mediawriter ranger corectrl \
    adw-gtk3-theme alsa-plugins-pulseaudio mesa-libOpenCL apr apr-util composer
echo
echo "All DNF packages installed."
echo
echo "Installing Python packages..."
pip install matplotlib numpy appdirs datetime pygame
echo 
echo "Installing Node packages..."
sudo npm install -g typescript tailwind live-server pm2 create-react-app express \
    mysql2 next nest expo
echo
echo "Installing Bun"
curl -fsSL https://bun.sh/install | bash
echo
echo "Installing Toipe with Cargo"
cargo install toipe
echo
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update
sudo dnf groupupdate 'core' 'multimedia' 'sound-and-video' --setop='install_weak_deps=False' --exclude='PackageKit-gstreamer-plugin' --allowerasing && sync
sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
sudo dnf install lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia
sudo dnf install ffmpeg ffmpeg-libs libva libva-utils
sudo dnf config-manager --set-enabled fedora-cisco-openh264
sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264
read -p "Are you using an AMD GPU? (y/n) " amd_gpu_response
if [ "$amd_gpu_response" == "y" ]; then
    sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
    echo "Installing LACT, a tool for controlling AMD GPUs."
    sudo dnf install ../apps/lact-0.4.4-0.x86_64.fedora-38.rpm
    sudo systemctl enable --now lactd
fi

echo 
echo "Done!"
echo
