#!/bin/bash

# 1. get user input if he/she wants to install nightly/latest version of nvim
read -p "Would you like to install \"nightly\" nvim build (y/n): " -n 1 -r
echo

rm -f ./nvim-linux64.tar.gz
# see https://github.com/neovim/neovim/blob/master/INSTALL.md#linux for more info
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo
	echo "Downloading nightly nvim verison..."
	curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
else
	echo
	echo "Downloading latest nvim verison..."
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
fi

# 2. install nvim
# cleanup
sudo rm -rf /opt/nvim
# installation
echo "Installing nvim..."
sudo tar -C /opt -xzvf ./nvim-linux64.tar.gz

# 3. delete nvim installation files tarball
sudo rm -rf nvim-linux64.tar.gz

echo "All Done!"
echo
echo "Close and reopen neovim for the changes to reflect"

