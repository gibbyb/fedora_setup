#!/bin/bash
unzip ~/Downloads/DaVinci_Resolve_18.5_Linux.zip -d \
    ~/Downloads/DaVinci_Resolve
chmod +x ~/Downloads/DaVinci_Resolve/DaVinci_Resolve_18.5_Linux.run
sudo ~/Downloads/DaVinci_Resolve/DaVinci_Resolve_18.5_Linux.run
sudo cp /lib64/libglib-2.0.* /opt/resolve/libs/
