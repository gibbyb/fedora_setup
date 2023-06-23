#!/bin/bash

echo
echo "Enrolling Key to MOK"
echo
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
echo
echo "Enroll the key once you reboot."
echo



#################### INSTALL FLATPAK PACKAGES #########################

echo
echo "Installing Flatpak packages..."
echo
flatpak install flathub -y sh.cider.Cider net.rpcs3.RPCS3 \
    com.discordapp.Discord com.obsproject.Studio com.mojang.Minecraft \
    org.libreoffice.LibreOffice org.yuzu_emu.yuzu net.davidotek.pupgui2 \
    com.mattjakeman.ExtensionManager org.gnome.gThumb org.gnome.Geary \
    org.gimp.GIMP org.kde.kdenlive com.slack.Slack com.github.xournalpp.xournalpp \
    de.haeckerfelix.Fragments com.prusa3d.PrusaSlicer \
    org.freecadweb.FreeCAD org.videolan.VLC com.bitwarden.desktop \
    com.github.PintaProject.Pinta com.heroicgameslauncher.hgl

# com.microsoft.Edge com.visualstudio.code giving Microsoft Edge RPM a chance even though it is 
# literally not as good as the flatpak, but it works with Webstorm, which is 
# a whole other problem on why I am even using Webstorm in the first place

######################### SET UP GIT ################################
git config --global user.name "gibbyb"
git config --global user.email "gib@gibbyb.com"
git config --global core.editor "nvim"
git config --global init.defaultBranch "main"
gh auth login


