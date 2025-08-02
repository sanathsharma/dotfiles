# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for a comprehensive development environment setup. The repository uses GNU Stow for symlink management to deploy configurations to the home directory.

## Key Commands

### Deployment
```bash
# Deploy all dotfiles to home directory
stow . -t ~
```

### Git Configuration
```bash
# Required for git worktrees in lazygit
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
```

### AI Commit Generation
```bash
# Generate AI-powered commit messages
./scripts/gen-commit.sh
```

### Git Workflow Scripts
- `./scripts/new-branch.sh` - Create new branch
- `./scripts/checkout-branch.sh` - Switch branches
- `./scripts/copy-branch.sh` - Copy branch name
- `./scripts/commit.sh` - Standard commit
- `./scripts/pr-url.sh` - Get PR URL
- `./scripts/commit-url.sh` - Get commit URL

## Architecture

### Configuration Structure
- `.config/` - Main configuration directory with tool-specific subdirectories
- `scripts/` - Shell scripts for git workflow and utilities
- `aipack/` - AI prompt configurations for commit generation

### Key Configuration Categories

**Development Tools:**
- `nvim/` - Neovim configuration with custom "minimalist" setup
- `git/` - Git configuration and aliases
- `lazygit/` - Terminal UI for git operations

**Terminal Environment:**
- `fish/` - Fish shell configuration
- `tmux/` - Terminal multiplexer setup
- `alacritty/` - GPU-accelerated terminal emulator
- `starship/` - Cross-shell prompt configuration

**System Tools:**
- `aerospace/` - Window manager for macOS
- `karabiner/` - Keyboard customization (macOS)
- `yazi/` - Terminal file manager
- `bat/` - Enhanced cat with syntax highlighting

### Neovim Architecture
The Neovim configuration follows a modular "minimalist" approach:
- `init.lua` - Entry point loading the minimalist module
- `minimalist/` - Core configuration module containing:
  - `lazy.lua` - Plugin manager setup
  - `lsp.lua` - Language server configurations
  - `keymaps.lua` - Custom key bindings
  - `options.lua` - Editor settings
  - `autocmds.lua` - Auto-commands
- `snippets/` - Code snippets organized by language

### Key Management
API keys and sensitive configuration are stored in `~/keys/`:
- `anthropic_key.txt` - Anthropic API key
- `openapi_key.txt` - OpenAI API key  
- `.gitconfig` - User-specific git configuration

## Development Environment

This dotfiles setup supports development in:
- **Rust** - Complete toolchain with rust-analyzer
- **Go** - Go toolchain with Delve debugger
- **Node.js** - Via nvm with latest LTS
- **Python** - System Python3 with pip/venv support
- **Lua** - For Neovim configuration and LuaRocks

The setup is designed for both Linux and macOS environments, with tool installation handled via package managers (apt, brew) and direct source installations where needed.