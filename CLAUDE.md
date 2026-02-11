# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for a comprehensive development environment setup. The repository uses GNU Stow for symlink management to deploy configurations to the home directory.

## Key Commands

### Deployment
```bash
# Deploy all dotfiles to home directory
stow . -t ~

# Files/patterns ignored by Stow are defined in .stow-local-ignore
```

### LSP and Formatter Installation
```bash
# Install all language servers and formatters at once
./scripts/install-lsps.sh

# See LSP.md and DAP.md for individual tool installation details
```

### AI-Powered Commit Generation
```bash
# Generate commit message using AI (requires aipack/aip tool)
gen-commit -v                    # Uses default model
gen-commit -m openai:gpt-4.1-mini  # Uses specific model

# Commit generation uses aipack/gen-commit.aip configuration
# Requires API keys in ~/dotlocal/anthropic_key.txt or ~/dotlocal/openapi_key.txt
# Generated message is written to tmp/commit-msg.txt
```

### Git Workflow Scripts
```bash
./scripts/new-branch.sh           # Create new branch
./scripts/switch-branch.sh        # Switch branches with FZF selector
./scripts/copy-branch.sh          # Copy current branch name to clipboard
./scripts/commit.sh              # Standard commit
./scripts/pr-url.sh              # Get PR URL for current branch
./scripts/commit-url.sh          # Get commit URL
./scripts/branch-summary.sh      # Generate branch summary
./scripts/create-release.sh      # Create git tag and GitHub release (use 'rel' abbreviation)
./scripts/symlink-mirror.sh      # Mirror directory structure with symlinks
```

### Git Worktree Configuration
```bash
# Required for git worktrees in lazygit
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
```

## Architecture

### Stow Deployment System
The repository uses GNU Stow to symlink configurations from `.config/` to `~/.config/`. Files listed in `.stow-local-ignore` are excluded from deployment (e.g., `.gitignore`, `.git`, `*.md`, `.idea`).

### Neovim "Minimalist" Architecture
The Neovim configuration uses a modular system that can be switched via the `CONFIG` environment variable:
- `init.lua` - Entry point: `require(os.getenv("CONFIG") or "minimalist")`
- `minimalist/init.lua` - Main configuration loader that:
  1. Enables vim.loader for faster startup
  2. Loads lazy.nvim plugin manager
  3. Applies options, autocmds, usercmds, and aliases
  4. Loads project-specific config from `.nvim.lua` if present
  5. Enables LSP configurations
  6. Sets rose-pine-main colorscheme

**Minimalist Module Structure:**
- `lazy.lua` - Plugin manager setup
- `lsp.lua` - LSP server configurations (uses system rust-analyzer, not Mason)
- `dap-adapters.lua` - Debug adapter configurations
- `keymaps.lua` - Custom key bindings
- `options.lua` - Editor settings
- `autocmds.lua` - Auto-commands
- `usercmds.lua` - User commands
- `aliases.lua` - Command aliases
- `project.lua` - Per-project configuration loader
- `utils.lua` - Helper functions
- `constants.lua` - Shared constants

### LSP Configuration Philosophy
- Prefers **system LSPs** over Mason-installed LSPs (especially for Rust)
- Uses `rustup component add rust-analyzer` for Rust (not Mason's standalone version)
- LSP installation is automated via `scripts/install-lsps.sh`
- See `LSP.md` for individual LSP setup instructions

### AI Commit Message Generation (aipack)
The `aipack/gen-commit.aip` file defines the commit message generation workflow:
1. Checks if in an Nx monorepo and loads scopes from `scopes.txt` if present
2. Gets current branch name and staged diff
3. Passes data to AI with conventional commit format instructions
4. Writes generated message to `tmp/commit-msg.txt`
5. Opens message in editor with `git commit -m "$(cat tmp/commit-msg.txt)" -e`

### Fish Shell Configuration
Fish shell is configured with:
- Vi mode with custom cursor shapes
- Zoxide for smart directory jumping
- Starship prompt
- Extensive abbreviations for common commands (see `.config/fish/config.fish:6-32`)
- API key loading from `~/dotlocal/` directory
- Custom functions for tmux session switching and git worktree navigation

### Key Management Structure
API keys and user-specific configuration stored in `~/dotlocal/`:
- `anthropic_key.txt` - Loaded to `$ANTHROPIC_API_KEY`
- `openapi_key.txt` - Loaded to `$OPENAI_API_KEY`
- `context7_key.txt` - Loaded to `$CONTEXT7_API_KEY` (for MCP servers)
- `.gitconfig` - User-specific git configuration (name, email, signingKey)

### Development Environment Support
- **Rust**: System rust-analyzer via rustup, cargo-watch for development
- **Go**: Go toolchain with Delve debugger, installed in `$GOPATH`
- **Node.js**: Via nvm, with various LSPs installed globally
- **Python**: System Python3 with pip/venv support
- **Lua**: For Neovim configuration with LuaRocks

### Platform-Specific Configurations
The setup handles both Linux and macOS:
- Fish abbreviations include OS-specific paths (`.config/fish/config.fish:34-41`)
- Separate Karabiner/Kanata configurations for keyboard customization
- Platform-specific path additions in Fish config

## Additional Documentation
- `README.md` - Detailed setup instructions for clean system installation
- `LSP.md` - Individual LSP server installation commands
- `DAP.md` - Debug adapter protocol setup
- `SSH.md` - SSH configuration guidance
- `AGENTS.md` - AI agent configurations