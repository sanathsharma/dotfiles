mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

alias vim = nvim
alias commit = sh ~/scripts/commit.sh
alias nb = sh	~/scripts/new-branch.sh
alias pr-url = sh ~/scripts/pr-url.sh
alias commit-url = sh ~/scripts/commit-url.sh
alias copy-branch = sh ~/scripts/copy-branch.sh
alias cat = bat
alias sb = sh ~/scripts/checkout-branch.sh
alias x = exit
alias d = docker
alias lg = lazygit -ucd ~/.config/lazygit
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

def ocat [...args] { /bin/cat ...$args }
