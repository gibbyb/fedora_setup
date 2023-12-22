#!/bin/bash
# Distrobox Install

read -p "Have you installed distrobox and created your fedora 38 image? (y/N) " answer_distrobox
if [ "$answer_distrobox" != "${answer_distrobox#[Yy]}" ] ;then
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 
    sudo dnf groupinstall -y "C Development Tools and Libraries" 
    sudo dnf groupinstall -y "Development Tools" 
    sudo dnf groupupdate 'core' 'multimedia' 'sound-and-video' --setop='install_weak_deps=False' \
        --exclude='PackageKit-gstreamer-plugin' --allowerasing && sync 
    sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing 
    sudo dnf install -y gstreamer1-plugins-{bad-*,good-*,base} \
        gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel\
        ffmpeg gstreamer-ffmpeg 
    sudo dnf install -y lame* --exclude=lame-devel
    sudo dnf group upgrade --with-optional Multimedia 
    sudo dnf install -y ffmpeg ffmpeg-libs libva libva-utils 
    sudo dnf config-manager --set-enabled fedora-cisco-openh264 
    sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264 
    read -p "Are you using an AMD GPU? (y/n) " amd_gpu_response 
    if [ "$amd_gpu_response" == "y" ]; then 
        sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld 
        sudo dnf install -y rocm-opencl 
    fi 
    read -p "Are you using an NVIDIA GPU? (y/n) " nv_gpu_response 
    if [ "$nv_gpu_response" == "y" ]; then 
        sudo dnf install -y akmod-nvidia  xorg-x11-drv-nvidia-cuda 
    fi 
    sudo dnf install -y alsa-plugins-pulseaudio libxcrypt-compat xcb-util-renderutil \
        xcb-util-wm pulseaudio-libs xcb-util xcb-util-image xcb-util-keysyms \
        libxkbcommon-x11 libXrandr libXtst mesa-libGLU mtdev libSM libXcursor libXi \
        libXinerama libxkbcommon libglvnd-egl libglvnd-glx libglvnd-opengl libICE \
        librsvg2 libSM libX11 libXcursor libXext libXfixes libXi libXinerama \
        libxkbcommon libxkbcommon-x11 libXrandr libXrender libXtst libXxf86vm \
        mesa-libGLU mtdev pulseaudio-libs xcb-util alsa-lib apr apr-util fontconfig \
        freetype libglvnd fuse-libs 
    cd ~/Downloads/DaVinci_Resolve 
    sudo ./DaVinci_Resolve_18.6.2_Linux.run 
    sudo cp /lib64/libglib-2.0.* /opt/resolve/libs/ 
    distrobox-export --app /opt/resolve/bin/resolve
    echo "Congratulations! You have installed Resolve!"
else
    sudo dnf install -y alsa-plugins-pulseaudio libxcrypt-compat xcb-util-renderutil \
       xcb-util-wm pulseaudio-libs xcb-util xcb-util-image xcb-util-keysyms \
       libxkbcommon-x11 libXrandr libXtst mesa-libGLU mtdev libSM libXcursor libXi \
       libXinerama libxkbcommon libglvnd-egl libglvnd-glx libglvnd-opengl libICE \
       librsvg2 libSM libX11 libXcursor libXext libXfixes libXi libXinerama libxkbcommon \
       libxkbcommon-x11 libXrandr libXrender libXtst libXxf86vm mesa-libGLU mtdev \
       pulseaudio-libs xcb-util alsa-lib apr apr-util fontconfig freetype libglvnd \
       fuse-libs rocm-opencl distrobox
    distrobox-create --name Fedora_38 --image fedora:38
    echo "Done! If you installed distrobox just now, run this script again to install Resolve."
    echo "Make sure to download Resolve!"
    echo "Entering Fedora_38 now."
    distrobox enter Fedora_38
fi
