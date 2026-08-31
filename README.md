### Setup guide

```sh
# Update and upgrade apt
apt update
apt upgrade

# Install curl
apt install curl

# Install git
apt install git-all

# Install xclip for clipboard ops
apt install xclip

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install fish

# Set default shell to fish
chsh -s /usr/bin/fish

# Install fisher, plugin manager for fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

brew install fzf zoxide stow tmux

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# NOTE: run `prefix + I` to install tpm and other plugins setup in `.config/tmux/tmux.conf`

# Install c compiler and build essential
apt install gcc build-essential

brew install lazygit lazydocker

# Install dtop, alternative/addon to lazydocker
cargo binstall dtop

brew install ripgrep fd

# Install bat from source
# cargo install --locked bat 
# Or
brew install bat
bat cache --build

# Install btop to monitor process
brew install btop

# Install psql for dadbod
apt install postgresql-client

# Install jq for json parcing and formatting for vim-rest-console (see https://jqlang.github.io/jq/ for more info)
brew install jq

brew install starship

# Install rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
# Update if already present
rustup update
source ~/.config/fish/config.fish

# Add rust analyzer, with stable toolchain
# This makes neovim use the same rust-analyzer verison as the compiler, avoiding editor not giving errors or giving unnecessary errors for example
rustup component add rust-analyzer

# Install yazi terminal UI file manager
cargo install --locked yazi-fm yazi-cli

# Install tree-sitter-cli for neovim treesitter parser installations
brew install tree-sitter-cli
```

### neovim version manager

```sh
cargo install bob-nvim
bob use nightly (or) bob use stable
```

# Install go (see <https://go.dev/doc/install> for more info)

GO_VERSION=go1.22.3 # go does not have releases, only tags. Which makes it deficult to get latest tag on the github repo
curl -Lo go.tar.gz <https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz>
rm -rf ~/go && tar -C ~/go -xzf go.tar.gz
rm go.tar.gz

# path is already part of .zshrc, add this variable to current shell session

export PATH=$PATH:/usr/local/go/bin

# Install delve for go debugging

go install github.com/go-delve/delve/cmd/dlv@latest

# Install gum for bash scripting

go install github.com/charmbracelet/gum@latest

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
stow . -t ~
```

### For working with git worktrees in lazygit, need to run the following command to be able to fetch remote

```sh
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
```

### Managing ai model keys

```sh
mkdir ~/dotlocal
cd ~/dotlocal
touch anthropic_key.txt
touch openapi_key.txt
```

Add the key for the respective models or model providers in the file, and the fish config shall load the keys to their
respective env var for the cli tools to use.

### Manageing MCP keys

```sh
mkdir ~/dotlocal
cd ~/dotlocal
touch context7_key.txt
```

Add the key for the respective mcp server api keys providers in the file, and the fish config shall load the keys to their
respective env var for the mcp server to use.

### Setting up git user details and signing key

```sh
cd ~/dotlocal
touch .gitconfig
```

add the following content to the ~/dotlocal/.gitconfig file

```ini
[user]
	name = <username>
	email = <noreply-email-id>
	signingKey = <path/to/pub-key>
```

### Commit message generator with AI

see https://github.com/sanathsharma/gen-commit for setup and usage


### Install rustowl for neovim

```sh
cargo install cargo-binstall
cargo binstall rustowl
```

Or see the docs for installtion script

https://github.com/cordx56/rustowl/blob/main/docs/installation.md#quick-start

### Install delta diffing tool for git commands

```sh
cargo install git-delta
```

### Install github cli

```sh
brew install gh
```

### Install gh-dash githuh cli extension

```sh
gh extension install gh-dash
```

### Install hunk

```sh
brew install hunk
```

### Install television

```sh
brew install television
```

### Install git-buttler

See https://docs.gitbutler.com/ai-agents/getting-started#install-the-but-cli

### Install lua runtime, to run cli scripts

```sh
brew install lua luarocks
luarocks install argparse
```

### Setup pass with gpg

1. Install gnupg if not yet installed "sudo apt install gnupg"
2. Generate a key with "gpg --full-generate-key"
3. All the keys can be listed with "gpg --list-keys"
4. The long hex string is the key id that can be used in "pass init <key-id>"
5. Or you can use the email-id from the key instead like so "pass init <email-id>"

### Install kitty

see https://sw.kovidgoyal.net/kitty/binary/#binary-install

add the kitty.desktop as per the docs for the kitty shortcut show up in the menu/launcher
