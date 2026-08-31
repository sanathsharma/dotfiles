#!/bin/sh
set -e

apt update -y
apt upgrade -y

apt install curl git-all xclip gcc build-essential postgresql-client -y

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

/home/linuxbrew/.linuxbrew/bin/brew install stow -y
/home/linuxbrew/.linuxbrew/bin/stow . -t ~
/home/linuxbrew/.linuxbrew/bin/brew install fish -y
/home/linuxbrew/.linuxbrew/bin/fish
chsh -s /home/linuxbrew/.linuxbrew/bin/fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

brew install fzf zoxide tmux lazygit lazydocker ripgrep fd bat btop jq starship dtop yazi gh hunk lua luarocks gum -y
bat cache --build
gh extension install gh-dash
luarocks install argparse

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
# Update if already present
rustup update
source ~/.config/fish/config.fish
rustup component add rust-analyzer

cargo install cargo-binstall
cargo binstall rustowl

cargo install git-delta

cargo install bob-nvim
bob use nightly (or) bob use stable

GO_VERSION=go1.27.0
curl -Lo go.tar.gz <https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz>
rm -rf ~/go && tar -C ~/go -xzf go.tar.gz
rm go.tar.gz

source ~/.config/fish/config.fish

curl -fsSL https://claude.ai/install.sh | bash

./install-lsps.sh
