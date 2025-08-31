#!/bin/sh

set -e

echo "Installing LSP servers and formatters..."

# TypeScript/JavaScript
echo "Installing TypeScript language server and Biome..."
npm install -g typescript typescript-language-server @biomejs/biome

# Lua
echo "Installing Lua language server..."
brew install lua-language-server

# TOML
echo "Installing Taplo for TOML..."
brew install taplo

# Tailwind CSS
echo "Installing Tailwind CSS language server..."
npm install -g @tailwindcss/language-server

# Emmet for HTML
echo "Installing Emmet language server..."
npm i -g @olrtg/emmet-language-server

# VSCode language servers (CSS, HTML, JSON, etc.)
echo "Installing VSCode language servers..."
npm i -g vscode-langservers-extracted

# Markdown
echo "Installing Marksman for Markdown..."
brew install marksman

# CSS Variables
echo "Installing CSS variables language server..."
npm i -g css-variables-language-server

# CSS Modules
echo "Installing CSS modules language server..."
npm install -g cssmodules-language-server

# Rust (requires rustup to be installed)
echo "Installing Rust analyzer..."
if command -v rustup >/dev/null 2>&1; then
    rustup component add rust-analyzer
else
    echo "Warning: rustup not found. Please install Rust first to add rust-analyzer."
fi

# Shell formatter
echo "Installing shfmt for shell formatting..."
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# YAML formatter
echo "Installing yamlfmt for YAML formatting..."
go install github.com/google/yamlfmt/cmd/yamlfmt@latest

# Lua formatter
echo "Installing stylua for Lua formatting..."
if command -v cargo >/dev/null 2>&1; then
    cargo install stylua
elif command -v brew >/dev/null 2>&1; then
    brew install stylua
else
    echo "Warning: Neither cargo nor brew found. Cannot install stylua."
fi

# JavaScript formatter
echo "Installing prettierd for fast JavaScript formatting..."
npm install -g @fsouza/prettierd

echo ""
echo "LSP installation complete!"
echo ""
echo "Note: For codebook spell checker, you need to manually:"
echo "1. Download the tar from https://github.com/blopker/codebook/releases"
echo "2. Run: tar -C ~/.local/bin -xzf <file-name>.tar.gz"
echo "3. Run: rm <file-name>.tar.gz"
echo ""
echo "Make sure you have the following prerequisites installed:"
echo "- Node.js and npm"
echo "- Homebrew (macOS/Linux)"
echo "- Go toolchain"
echo "- Rust toolchain (rustup/cargo)"
