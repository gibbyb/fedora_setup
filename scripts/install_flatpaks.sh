#!/bin/bash

echo
echo "Installing Flatpak packages..."
echo
flatpak install flathub -y sh.cider.Cider net.rpcs3.RPCS3 \
    com.discordapp.Discord com.obsproject.Studio com.mojang.Minecraft \
    org.libreoffice.LibreOffice org.yuzu_emu.yuzu com.vysp3r.ProtonPlus \
    com.mattjakeman.ExtensionManager org.gnome.gThumb org.gnome.Geary \
    org.gimp.GIMP org.kde.kdenlive com.slack.Slack \
    com.github.xournalpp.xournalpp de.haeckerfelix.Fragments \
    com.prusa3d.PrusaSlicer com.unity.UnityHub \
    org.freecadweb.FreeCAD org.videolan.VLC com.bitwarden.desktop \
    com.github.PintaProject.Pinta io.github.Foldex.AdwSteamGtk \
    com.endlessnetwork.aqueducts org.ardour.Ardour \
    app.bluebubbles.BlueBubbles com.usebottles.bottles org.citra_emu.citra \
    ro.go.hmlendea.DL-Desktop com.dec05eba.gpu_screen_recorder \
    io.github.jeffshee.Hidamari org.apache.netbeans org.libretro.RetroArch \
    uk.org.greenend.chiark.sgtatham.putty org.srb2.SRB2 \
    net.supertuxkart.SuperTuxKart com.github.unrud.VideoDownloader \
    org.gnome.gitlab.YaLTeR.VideoTrimmer tv.plex.PlexDesktop \
    com.github.micahflee.torbrowser-launcher fr.handbrake.ghb \
    com.orama_interactive.Pixelorama re.sonny.Workbench

echo
echo "Done!"
echo
