def extend-path [paths: list<string>] {
	let expanded_paths = $paths | each { |path| $path | path expand }
	$env.PATH = ($env.PATH | prepend $expanded_paths)
}

def path-exists [path: string] {
	$path | path expand | path exists
}

def dir-exists [path: string] {
	let expanded_path = $path | path expand
	($expanded_path | path exists) and (($expanded_path | path type) == "dir")
}

def file-exists [path: string] {
	let expanded_path = $path | path expand
	($expanded_path | path exists) and (($expanded_path | path type) == "file")
}

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

alias vim = nvim
alias commit = sh ($nu.home-path)/scripts/commit.sh
alias nb = sh	($nu.home-path)/scripts/new-branch.sh
alias pr-url = sh ($nu.home-path)/scripts/pr-url.sh
alias commit-url = sh ($nu.home-path)/scripts/commit-url.sh
alias copy-branch = sh ($nu.home-path)/scripts/copy-branch.sh
alias cat = bat
alias sb = sh ($nu.home-path)/scripts/checkout-branch.sh
alias x = exit
alias d = docker
alias lg = lazygit -ucd ($nu.home-path)/.config/lazygit
alias k = kubectl
alias fm = yazi
alias ss = do { sudo shutdown -h now }
alias sr = do { sudo shutdown -r now }
alias u = do { sudo apt update; sudo apt upgrade }
alias zz = cd -
alias sro = git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
alias gc = gen-commit
alias gco = gen-commit -m openai:get-4.1-mini
alias gcv = gen-commit -v
alias gcov = gen-commit -m openai:get-4.1-mini -v
alias clip = xclip -selection clipboard
alias s = kitten ssh
alias w = cd (worktree)

def ocat [...args] { /bin/cat ...$args }

source $"($nu.home-path)/.cargo/env.nu"

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.GIT_EDITOR = "nvim"
$env.GO_PATH = "($nu.home-path)/go"
$env.STARSHIP_CONFIG = "($nu.home-path)/.config/starship/starship.toml"
$env.GPG_TTY = (tty)
$env.FZF_DEFAULT_OPTS = """
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
--color=selected-bg:#45475a
--preview=\"bat --style=numbers --color=always {}\"
--height=20
--reverse
--multi"""
$env.VOLTA_HOME = "($nu.home-path)/.volta"

let new_paths = [
	"($nu.home-path)/bin"
	"($nu.home-path)/.local/bin"
	"/opt/local/bin"
	"/root/.local/bin"
	"($nu.home-path)/.local/kitty.app/bin"
	"/sbin"
	"($nu.home-path)/go"
	"($env.GOPATH)/bin"
	"/usr/bin"
	"($nu.home-path)/jetbrains-toolbox/bin"
	"($nu.home-path)/.codeium/windsurf/bin"
	"/usr/local/go/bin"
	"/opt/homebrew/bin"
	"($nu.home-path)/.cargo/bin"
	"($env.VOLTA_HOME)/bin"
]
extend-path $new_paths

let postgres15_path = "/opt/homebrew/opt/postgresql@15"
let postgres15_bin_path = $postgres15_path + "/bin"
if (dir-exists $postgres15_bin_path) {
	extend-path [$postgres15_bin_path]

	$env.LDFLAGS = "-L" + $postgres15_path + "/lib"
	$env.CPPFLAGS = "-I" + $postgres15_path + "/include"
}

