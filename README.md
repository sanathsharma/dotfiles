### Setup guide

```sh
# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install fish

# Set default shell to fish
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s $(which fish)

# Install fisher, plugin manager for fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

brew install fzf zoxide stow tmux

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install psql for dadbod
apt install postgresql-client

# Install jq for json parcing and formatting for vim-rest-console (see https://jqlang.github.io/jq/ for more info)
brew install jq

# Install rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
# Update if already present
rustup update
source ~/.config/fish/config.fish

# Add rust analyzer, with stable toolchain
# This makes neovim use the same rust-analyzer verison as the compiler, avoiding editor not giving errors or giving unnecessary errors for example
rustup component add rust-analyzer

# Install yazi terminal UI file manager
brew install yazi resvg chafa

# Install tree-sitter-cli for neovim treesitter parser installations
brew install tree-sitter-cli
```

### neovim version manager

```sh
cargo install bob-nvim
bob use nightly (or) bob use stable
```

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
gh extension install dlvhdr/gh-dash
```

### Install hunk

```sh
brew install hunk
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

### Secretspec init

```sh
secretspec config global init
```

### Install kitty

see https://sw.kovidgoyal.net/kitty/binary/#binary-install

add the kitty.desktop as per the docs for the kitty shortcut show up in the menu/launcher
