if status is-interactive
	# Commands to run in interactive sessions can go here
end

# Abbreviations
abbr -a c "clear"
abbr -a lg "lazygit"
abbr -a x "exit"
abbr -a v "nvim"
abbr -a sv "sudo nvim"
abbr -a cwr "cargo watch -q -c -w src/ -w .cargo/ -x run"
abbr -a cwt "cargo watch -q -c -x \"test -- --nocapture\""
abbr -a cr "cargo run"
abbr -a ld "lazydocker"
abbr -a d "docker"
abbr -a k "kubectl"
abbr -a z "zellij"
abbr -a fm "yazi"
abbr -a ss "sudo shutdown -h now"
abbr -a u "sudo apt update && sudo apt upgrade"

# Alias
alias ls="ls --color"
alias vim="nvim"
alias tmux="tmux -u"

# Path
# For Linux
fish_add_path /opt/nvim-linux64/bin
fish_add_path /root/.local/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
fish_add_path /sbin
fish_add_path $HOME/go
fish_add_path $GOPATH/bin
# Go entry
fish_add_path /usr/local/go/bin
# MacOS specific
fish_add_path $HOME/nvim-macos-arm64/bin
fish_add_path $HOME/Library/Python/3.x/bin
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.cargo/bin

# Set variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set fish_greeting ""
set --universal nvm_default_version 20.18.0

# Bindings
bind --mode insert \cf forward-char
bind --mode insert --sets-mode default jk repaint # Bind jk to escape of insert mode
bind --mode default --mode insert \cp history-search-backward
bind --mode default --mode insert \cn history-search-forward

# Initialization
zoxide init --cmd cd fish | source
oh-my-posh init fish --config ~/.config/ohmyposh/base.toml | source

# Enable vi mode
set -g fish_key_bindings fish_vi_key_bindings
set -g fish_vi_force_cursor 1

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursors to an underscore
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
# Set the external cursor to a line. The external cursor appears when a command is started.
# The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
set fish_cursor_external line
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block
