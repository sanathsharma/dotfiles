if status is-interactive
	# Commands to run in interactive sessions can go here
end

# Abbreviations
abbr -a c clear
abbr -a lg "lazygit -ucd ~/.config/lazygit"
abbr -a x exit
abbr -a sv "sudo nvim"
abbr -a ld lazydocker
abbr -a d docker
abbr -a k kubectl
abbr -a fm yazi
abbr -a ss "sudo shutdown -h now"
abbr -a sr "sudo shutdown -r now"
abbr -a u "sudo apt update && sudo apt upgrade"
abbr -a zz "cd -"
abbr -a clip "wl-copy"
abbr -a s "kitten ssh"
abbr -a nb "new-branch.sh"
abbr -a sb "switch-branch.sh"
abbr -a up "update.sh"
abbr -a sro "git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'"
abbr -a gc "gen-commit -v"
abbr -a gco "gen-commit -m openai::gpt-4.1-mini"
abbr -a gccl "lua ~/scripts/commit-claude.lua"
abbr -a gcoo "gen-commit -m ollama::gpt-oss:20b --verbose"
abbr -a rel "create-release.sh"
abbr -a j "just"
abbr -a cw "create-worktree.sh"
abbr -a nw "create-worktree.sh"
abbr -a t "tmux"
abbr -a ta "tmux a"
abbr -a wifi "impala"
abbr -a bluetooth "bluetui"
abbr -a commit "sh ~/scripts/commit.sh"
abbr -a h "hunk diff"
abbr -a hash "openssl rand -base64 32"
abbr -a so "source ~/.config/fish/config.fish && fish_user_key_bindings"

# Alias
alias ls="exa -l --icons -a --git"
alias neovim="$(which nvim)"
alias vim="neovim"
alias tmux="tmux -u -f ~/.config/tmux/tmux.conf"
# use https://github.com/sanathsharma/gen-commit instead
# alias gen-commit="sh ~/scripts/gen-commit.sh"
alias ocat="$(which cat)"
alias cat="bat"
alias dr="sh ~/scripts/debug_rust.sh"
alias op="cd ~/vaults/personal"
alias ow="cd ~/vaults/work"
alias scratch="yazi ~/vaults/scribble"
alias ga="git add --patch"
alias gaa="git add --all"
alias gp="git pull"
alias gP="git push"
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias npm="bun"
alias ni="bun install"
alias npx="bun run"
alias jl="_fzf_search_just_commands"
alias nvim="PROFILE=minimalist neovim"

# Set variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx GIT_EDITOR nvim
set -gx GOPATH $HOME/go
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
set -gx GPG_TTY "$(tty)"
set fish_greeting ""
set -Ux FZF_DEFAULT_OPTS "\
--preview=\"bat --style=numbers --color=always {}\" \
--height=20 \
--reverse \
--bind \"change:first\" \
--multi \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
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
fish_add_path $HOME/.local/kitty.app/bin
fish_add_path $HOME/bin
fish_add_path /sbin
fish_add_path $HOME/go
fish_add_path $GOPATH/bin
fish_add_path /usr/bin
fish_add_path $HOME/scripts
fish_add_path $HOME/.local/share/bob/nvim-bin
# Go entry
fish_add_path /usr/local/go/bin
# MacOS specific
fish_add_path $HOME/nvim-macos-arm64/bin
fish_add_path $HOME/Library/Python/3.x/bin
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.cargo/bin
fish_add_path "$HOME/Library/PostgreSQL/16/bin"
fish_add_path /usr/local/bin
fish_add_path /run/current-system/sw/bin
fish_add_path "$HOME/.rustowl"

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
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)"
	# Keep system binaries (e.g. dbus-monitor) taking precedence over Linuxbrew's
	# shims, which can be built with incompatible defaults (e.g. a D-Bus socket
	# path baked in under the Linuxbrew prefix instead of the real system bus).
	fish_add_path --move /usr/bin
	fish_add_path --move /sbin
end

if command -q luarocks
	# luarocks installs rocks into its configured tree but never puts them on
	# Lua's search path itself; without this, `require()` can't find anything
	# `luarocks install` just installed.
	set -gx LUA_PATH (luarocks path --full --lr-path)
	set -gx LUA_CPATH (luarocks path --full --lr-cpath)
end

if test -e $HOME/dotlocal/anthropic_key.txt
	set -x ANTHROPIC_API_KEY $(cat $HOME/dotlocal/anthropic_key.txt)
end

if test -e $HOME/dotlocal/openapi_key.txt
	set -x OPENAI_API_KEY $(cat $HOME/dotlocal/openapi_key.txt)
end

if test -e $HOME/dotlocal/context7_key.txt
	set -x CONTEXT7_API_KEY $(cat $HOME/dotlocal/context7_key.txt)
end

# functions
function w
	set result (worktree $argv)
	if test -n "$result"
		cd $result
	end
end

function sesh_load_worktree
	set result (worktree $argv)
	if test -n "$result"
		sesh connect $result
	end
end

function sesh_load
	set result (sesh list | fzf)
	if test -n "$result"
		sesh connect $result
	end
end

function dbui
	if test -z "$argv[1]"
		echo "Usage: dbui <db-connection-url>"
		return 1
	end
	nvim -c "DBConnect $argv[1]"
end

function spec-dbui
	set -l urls

	for name in $argv
		if set -l val (secretspec get $name 2>/dev/null)
			and test -n "$val"
			set -a urls $val
		else
			echo "skipping $name (not found or empty)" >&2
		end
	end

	if test (count $urls) -eq 0
		echo "no valid secrets found for: $argv" >&2
		return 1
	end

	dbui $urls
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

if test -e $HOME/dotlocal/local_config.fish
	source $HOME/dotlocal/local_config.fish
end

# Reset terminal modes on exit, so that escape sequences are not left over
function __reset_terminal --on-event fish_postexec
	printf '\e[<u\e[?1000l\e[?1002l\e[?1003l\e[?1006l'
	timeout 0.05 dd of=/dev/null bs=1 count=4096 2>/dev/null
end

# Initialization
zoxide init --cmd cd fish | source
starship init fish | source

# Added by GitButler installer
but completions fish | source
