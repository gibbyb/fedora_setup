#!/bin/bash

echo "Opening packer.lua. Source the file and run \":PackerSync\""
kitty -1 -e bash -c "nvim /home/gib/.config/nvim/lua/gib_nvim/packer.lua"
read -p "Once complete, close window & press enter to continue."
echo "Copying after directory to ~/.config/nvim"
cp ./nvim/after/* /home/$username/.config/nvim/after/
chown -R $username:$username /home/$username/.config/nvim/after
echo "Opening neovim. Run \":Mason\" and install the extensions you want."
echo "You can also run \":Copilot setup\" to setup GitHub Copilot."
kitty -1 -e "nvim"
read -p "Once complete, close neovim and press enter to continue."

