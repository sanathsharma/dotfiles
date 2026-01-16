if status is-interactive
	# Commands to run in interactive sessions can go here
end

# Abbreviations
abbr -a c clear
abbr -a lg "lazygit -ucd ~/.config/lazygit"
abbr -a gui gitui
abbr -a x exit
abbr -a sv "sudo nvim"
abbr -a cwr "cargo watch -q -c -w src/ -x run"
abbr -a cwrc "cargo watch -q -c -w src/ -w .cargo/ -x run"
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
abbr -a clip "xclip -selection clipboard"
abbr -a s "kitten ssh"
abbr -a nb "new-branch.sh"
abbr -a sb "switch-branch.sh"
abbr -a sro "git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'"
abbr -a gc "gen-commit -v"
abbr -a gco "gen-commit -m openai:gpt-4.1-mini"
abbr -a gcoc "sh ~/scripts/commit-opencode.sh"

set os (uname)
if test $os = "Darwin"
	abbr -a hrm "kanata -c ~/.config/kanata/macos/config.kbd"
	abbr -a colemak "kanata -c ~/.config/kanata/macos/colemak.kbd"
else
	abbr -a hrm "kanata -c ~/.config/kanata/linux/config.kbd"
	abbr -a colemak "kanata -c ~/.config/kanata/linux/colemak.kbd"
end

# Alias
alias ls="ls --color"
alias vim="nvim"
alias tmux="tmux -u -f ~/.config/tmux/tmux.conf"
# use https://github.com/sanathsharma/gen-commit instead
# alias gen-commit="sh ~/scripts/gen-commit.sh"
alias ocat="$(which cat)"
alias cat="bat"
alias dr="sh ~/scripts/debug_rust.sh"
alias op="cd ~/vaults/personal"
alias ow="cd ~/vaults/work"

# Set variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx GIT_EDITOR nvim
set -gx GOPATH $HOME/go
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
set -gx GPG_TTY "$(tty)"
set fish_greeting ""
set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--preview=\"bat --style=numbers --color=always {}\" \
--height=20 \
--reverse \
--bind \"change:first\" \
--multi"
# set -Ux FZF_DEFAULT_COMMAND "rg --files --hidden --glob '!.git/*' --glob '!**/.git/*'"
# set -Ux FZF_DEFAULT_COMMAND "fd --type file --hidden --no-ignore"
set -Ux FZF_DEFAULT_COMMAND ""
set -Ux FZF_COMPLETION_TRIGGER "~~"
set -gx VOLTA_HOME "$HOME/.volta"

# Path
# For Linux
fish_add_path $VOLTA_HOME/bin
fish_add_path /opt/nvim-linux64/bin
fish_add_path /root/.local/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.local/Webstorm/bin
fish_add_path $HOME/.local/kitty.app/bin
fish_add_path $HOME/bin
fish_add_path /sbin
fish_add_path $HOME/go
fish_add_path $GOPATH/bin
fish_add_path /usr/bin
fish_add_path $HOME/jetbrains-toolbox/bin
fish_add_path $HOME/.codeium/windsurf/bin
fish_add_path $HOME/scripts
fish_add_path $HOME/.opencode/bin
fish_add_path $HOME/.antigravity/antigravity/bin
fish_add_path $HOME/.local/share/bob/nvim-bin
# Go entry
fish_add_path /usr/local/go/bin
# MacOS specific
fish_add_path $HOME/nvim-macos-arm64/bin
fish_add_path $HOME/Library/Python/3.x/bin
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.cargo/bin
fish_add_path "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fish_add_path "$HOME/.aipack-base/bin"
fish_add_path "$HOME/Library/PostgreSQL/16/bin"
fish_add_path /usr/local/bin
fish_add_path /run/current-system/sw/bin

if test -d /opt/homebrew/opt/postgresql@15/bin
	fish_add_path /opt/homebrew/opt/postgresql@15/bin

	set -gx LDFLAGS "-L/opt/homebrew/opt/postgresql@15/lib"
	set -gx CPPFLAGS "-I/opt/homebrew/opt/postgresql@15/include"
end

# Bindings
bind --mode insert \cf forward-char
bind --mode insert \cy forward-char
# bind --mode insert --sets-mode default jk repaint # Bind jk to escape of insert mode
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

if test -e $HOME/dotlocal/anthropic_key.txt
	set -gx ANTHROPIC_API_KEY $(cat $HOME/dotlocal/anthropic_key.txt)
end

if test -e $HOME/dotlocal/openapi_key.txt
	set -gx OPENAI_API_KEY $(cat $HOME/dotlocal/openapi_key.txt)
end

if test -e $HOME/dotlocal/context7_key.txt
	set -gx CONTEXT7_API_KEY $(cat $HOME/dotlocal/context7_key.txt)
end

# functions
function w
	set result (worktree $argv)
	if test -n "$result"
		cd $result
	end
end

function tmsw
	set result (worktree $argv)
	if test -n "$result"
		sesh connect $result
	end
end

function tms
  set result (sesh list | fzf)
  if test -n "$result"
    sesh connect $result
  end
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
