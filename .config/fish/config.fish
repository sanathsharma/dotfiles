if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Abbreviations
abbr -a c clear
abbr -a lg "lazygit -ucd ~/.config/lazygit"
abbr -a x exit
abbr -a v nvim
abbr -a sv "sudo nvim"
abbr -a cwr "cargo watch -q -c -w src/ -w .cargo/ -x run"
abbr -a cwt "cargo watch -q -c -x \"test -- --nocapture\""
abbr -a cr "cargo run"
abbr -a ld lazydocker
abbr -a d docker
abbr -a k kubectl
abbr -a z zellij
abbr -a fm yazi
abbr -a ss "sudo shutdown -h now"
abbr -a sr "sudo shutdown -r now"
abbr -a u "sudo apt update && sudo apt upgrade"
abbr -a zz "cd -"
abbr -a vvim "NVIM_APPNAME=nvim-vscode nvim"

# Alias
alias ls="ls --color"
alias vim="nvim"
alias tmux="tmux -u"
alias commit="sh ~/scripts/commit.sh"
alias new-branch="sh ~/scripts/branch.sh"
alias cat="bat"

# Set variables
set -gx EDITOR hx
set -gx VISUAL hx
set -gx GOPATH $HOME/go
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
set fish_greeting ""
set --universal nvm_default_version 20.18.0
set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

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

# Bindings
bind --mode insert \cf forward-char
bind --mode insert \cy forward-char
bind --mode insert --sets-mode default jk repaint # Bind jk to escape of insert mode
bind --mode default --mode insert \cp history-search-backward
bind --mode default --mode insert \cn history-search-forward

# Initialization
zoxide init --cmd cd fish | source
# oh-my-posh init fish --config ~/.config/ohmyposh/base.toml | source
starship init fish | source

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

if test -e /home/linuxbrew/.linuxbrew/bin/brew
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end
