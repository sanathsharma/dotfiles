### Setup guide

```sh
# Update and upgrade apt
apt update
apt upgrade

# Install git
apt install git-all

# Install zsh
apt install zsh

# Set default shell to zsh
chsh -s /usr/bin/zsh

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
sudo install lazygit /usr/local/bin

# Install ripgrep
apt install ripgrep

# Install htop to moniter process
apt intall htop

# Install nodejs via nvm (see https://nodejs.org/en/download/package-manager for more info)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# resource to make nvm available
source ~/.bashrc
source ~/.zshrc
nvm install 20
node -v
npm -v

# Install neovim
# for latest
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
# for nightly
# curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar -C /opt -xzvf ./nvim-linux64.tar.gz
rm -f ./nvim-linux64.tar.gz

# Install rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

# Add rust analyzer, with stable toolchain
# This makes neovim use the same rust-analyzer verison as the compiler, avoiding editor not giving errors or giving unnecessary errors for example
rustup toolchain install stable
rustup component add rust-analyzer

# Install go from https://go.dev/doc/install
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

