### Setup guide

```sh
# Update and upgrade apt
apt update
apt upgrade

# Install curl
apt install curl

# Install zip (for mason)
apt install zip

# Install git
apt install git-all

# Install zsh
apt install zsh

# Set default shell to zsh
chsh -s /usr/bin/zsh

# Or install Fish
# See https://github.com/fish-shell/fish-shell?tab=readme-ov-file#packages-for-linux for setup
# Following steps for debian based linux
sudo apt-add-repository ppa:fish-shell/release-3
# Might need to install python3-launchpadlib if above command throws
# error: AttributeError: 'NoneType' object has no attribute 'people'
sudo apt install python3-launchpadlib
sudo apt update
sudo apt install fish

# Set default shell to fish
chsh -s /usr/bin/fish

# Install fisher, plugin manager for fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Install GNU stow
apt install stow

# Install fzf from source (see https://github.com/junegunn/fzf?tab=readme-ov-file#using-git for more info)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install zoxide from source (see https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation for more info)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install tmux
apt install tmux

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# NOTE: run `prefix + I` to install tpm and other plugins setup in `.config/tmux/tmux.conf`

# Install c compiler and build essential
apt install gcc build-essential

# Install lazygit (see https://github.com/jesseduffield/lazygit?tab=readme-ov-file#binary-releases for more info)
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin
rm -rf lazygit lazygit.tar.gz

# Install lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Install ripgrep
apt install ripgrep

# Install htop to moniter process
apt install htop

# Install psql for dadbod
apt install postgresql-client

# Install jq for json parcing and formatting for vim-rest-console (see https://jqlang.github.io/jq/ for more info)
apt install jq

# Install lua for luarocks installation (required by rest.nvim)
apt install lua5.1 liblua5.1-dev libcurl4-openssl-dev

# Install luarocks from their site
# See https://luarocks.org/#quick-start for installation steps of latest luarocks

# Install lua-curl
# Use `find /usr -name curl.h` to find the include directory for curl headers
luarocks install lua-curl CURL_INCDIR=/usr/include/x86_64-linux-gnu

# Install nodejs via nvm (see https://nodejs.org/en/download/package-manager for more info)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# resource to make nvm available
source ~/.bashrc
source ~/.zshrc
nvm install 20
node -v
npm -v

# Install ohmyposh
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin

# Install neovim
# for latest
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
# for nightly
# curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar -C /opt -xzvf ./nvim-linux64.tar.gz
rm -f ./nvim-linux64.tar.gz

# Install rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
# Update if already present
rustup update
# resource to make rustup available
source ~/.bashrc
source ~/.zshrc

# Add rust analyzer, with stable toolchain
# This makes neovim use the same rust-analyzer verison as the compiler, avoiding editor not giving errors or giving unnecessary errors for example
rustup component add rust-analyzer

# Install yazi terminal UI file manager
cargo install --locked yazi-fm yazi-cli

# Install go (see https://go.dev/doc/install for more info)
GO_VERSION=go1.22.3 # go does not have releases, only tags. Which makes it deficult to get latest tag on the github repo
curl -Lo go.tar.gz https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz
# path is already part of .zshrc, add this variable to current shell session
export PATH=$PATH:/usr/local/go/bin

# Install delve for go debugging
go install github.com/go-delve/delve/cmd/dlv@latest

# Python, assuming python3 is already pre-installed
# following are required for installing ruff, mypy etc. by mason
sudo apt install python3-venv python3-virtualenv python3-pip
```

### Check the source of rust-analyzer
You can confirm if your setup is using your system LSP via :checkhealth rustaceanvim after opening a Rust file:

```txt
Checking external dependencies
- OK rust-analyzer: found rust-analyzer 1.75.0 (82e1608 2023-12-21)
If instead you had accidentally installed Mason's rust-analyzer, this check would say something like

- OK rust-analyzer: found rust-analyzer 0.3.1799-standalone
In that event you could remove the Mason version with :MasonUninstall rust-analyzer.
```

see [stackexchange-thread](https://vi.stackexchange.com/questions/43681/simplest-setup-for-nvim-and-rust-and-system-rust-analyzer) for more info

### To symlink the dotfiles to root/home folder, run the following command from within the `dotfiles` dir
```sh
stow .
```

### For working with git worktrees in lazygit, need to run the following command to be able to fetch remote

```sh
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
```
