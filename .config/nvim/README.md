## neovim custom configuration

### LSPs configured
- tsserver
- gopls
- rust_analyser
- jsonls
- marksman (markdown files)
- yamlls

### Quick installation
#### linux/docker-container
```sh 
curl -fsSL https://raw.githubusercontent.com/sanathsharma/neovim-config/main/setup/linux-install.sh > setup.sh
chmod +x setup.sh
./setup.sh
rm setup.sh
```

Run `<C-space> I` from within a tmux sesson to install all tmux plugins

### Upgrade
```sh 
curl -fsSL https://raw.githubusercontent.com/sanathsharma/neovim-config/main/setup/linux-upgrade-nvim.sh > setup.sh
chmod +x setup.sh
./setup.sh
rm setup.sh
```

### LazyGit installation
see [lazygit-github-installation-setup](https://github.com/jesseduffield/lazygit?tab=readme-ov-file#installation) for more info

### `gx` command enabling
install xdg-utils to make xdg-open command available to nvim to use gx command
```sh
apt install xdg-utils
```

### Rust, rust analyzer installation
install stable toolchain
```sh
rustup toolchain install stable
```
```sh
rustup component add rust-analyzer
```
This makes neovim use the same rust-analyzer verison as the compiler, avoiding editor not giving errors or giving unnecessary errors for example

#### Check the source of rust-analyzer

```
You can confirm if your setup is using your system LSP via :checkhealth rustaceanvim after opening a Rust file:

Checking external dependencies
- OK rust-analyzer: found rust-analyzer 1.75.0 (82e1608 2023-12-21)
If instead you had accidentally installed Mason's rust-analyzer, this check would say something like

- OK rust-analyzer: found rust-analyzer 0.3.1799-standalone
In that event you could remove the Mason version with :MasonUninstall rust-analyzer.
```

see [stackexchange-thread](https://vi.stackexchange.com/questions/43681/simplest-setup-for-nvim-and-rust-and-system-rust-analyzer) for more info

### Example launch.json
For node.js
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "pwa-node",
            "request": "launch",
            "name": "Launch Node App",
            "cwd": "${workspaceFolder}",
            "runtimeArgs": [
                "--harmony"
            ],
            "restart": true,
            "stopOnEntry": false,
            "program": "/root/.nvm/versions/node/v20.13.1/lib/node_modules/npm",
            "args": [
                "run",
                "dev"
            ]
        }
    ]
}
```

### helpful git config to easy git experience (personal preference)
```sh
git config --global pull.rebase true
```
### Commands and keymaps

- `:<linenumber>` - take cursor to specified line number
- `{` - go to previous empty line
- `}` - go to next empty line
- `zf` - create a manual fold
- `za` - toggle a fold
- `[c` - go to previous hunk
- `]c` - go to next hunk
- `(` - Jump to the previous file, hunk, or revision.
- `)` - Jump to the next file, hunk, or revision.
- `:Telescope git_commits` - fuzzy search git commits
- `:Telescope git_branches` - fuzzy search git branches
- `:Git` - git status
- `:Git mergetool` - open git merge tool
- `:Git difftool` - open git diff tool
- `[d` - go to previous error diagnostics
- `]d` - go to next error diagnostics
- `:mkview` - write folds into a file
- `:loadview` - read folds into a file
- `:bd` - close current buffers
- `:bp` - switch to previous buffer
- `:bn` - switch to next buffer
- `:bufdo bd` - close all buffers (INFO: will execute the following command for all buffers)
- `gg` - go to top of the file
- `G` - go to bottom of the file
- `:split` - split horizontal window
- `:vsplit` - split vertical window
- `<C-w> *` - window options including re-sizing
- `>>` - normal mode; indent code right
- `<<` - normal mode; indent code left
- `<` - visual mode; indent code left
- `>`- visual mode; indent code left
- `:%s/<old-name>/<new-name>/g` - rename something in a file with a new value
- `.` - repeat
- `:<cmd> | only` - `:only` is the command that will make the current window the only window visible.
- `:so` - re source nvim config
- `H` - go to top line, in visible range
- `L` - go to bottom line, in visible range
- `<C-i>` - jump to the next location in the jump list
- `<C-o>` - jump to the previous location in the jump list
- `/` - search in file
- `*` - search word under the cursor, with in the file
- `n` - go to next instance of search word
- `N` - go to previous instance of search word
- `\\` - open terminal
- = - auto indent selected line in visual mode
- <n>== - auto indent next n lines
- `][` - jump to next end of code block
- `[]` - jump to previous start of code block
- `]}` - jump to end of current code block
- `[{` - jump to start of current code block
- `%` - jump to matching closing or opening braces
- `z=` - suggestion for spell fix
- `zg` - add a word as good word to the spell file
- `zz` - move current line to center of the screen
- `zt` - move current line to top of the screen
- `zb` - move current line to bottom of the screen
- <C-e> (Ctrl + e): Scroll the page down by one line without moving the cursor.
- <C-y> (Ctrl + y): Scroll the page up by one line without moving the cursor.
- <C-d> (Ctrl + d): Scroll the page down by half a screen without moving the cursor.
- <C-u> (Ctrl + u): Scroll the page up by half a screen without moving the cursor.
- <C-f> (Ctrl + f): Scroll the page down by a full screen without moving the cursor.
- <C-b> (Ctrl + b): Scroll the page up by a full screen without moving the cursor.
- `D` - delete from cursor position to end of line
- `S` - delete current line and start editing
