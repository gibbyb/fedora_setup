#!/bin/bash 

echo "Installing and Configuring Neovim"
dnf install -y neovim 
# Make nvim config directory if it doesn't exists
if [ ! -d "~/.config/nvim" ]; then
    echo "Creating ~/.config/nvim directory"
    mkdir ~/.config/nvim
fi
echo "Copying init.lua and lua directory to ~/.config/nvim"
cp ./nvim/init.lua ~/.config/nvim/init.lua
mkdir -p ~/.config/nvim/lua/gib_nvim
cp ./nvim/lua/gib_nvim/* ~/.config/nvim/lua/gib_nvim/
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim 
echo "Opening packer.lua. Source the file and run \":PackerSync\""
kitty -1 -e bash -c "nvim /home/gib/.config/nvim/lua/gib_nvim/packer.lua"
read -p "Once complete, close window & press enter to continue."
echo "Copying after directory to ~/.config/nvim"
cp ./nvim/after/* ~/.config/nvim/after/
echo "Opening neovim. Run \":Mason\" and install the extensions you want."
echo "You can also run \":Copilot setup\" to setup GitHub Copilot."
kitty -1 -e "nvim"
read -p "Once complete, close neovim and press enter to continue."

