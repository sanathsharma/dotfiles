function _fzf_search_git_remote_branch
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Not a git repository."
        return 1
    end

    set branches (git branch -r | \
        sed 's/^[*+ ] //' | \
        sed 's/^remotes\///' | \
        grep -v 'HEAD' | \
        sort -u)

    set preview_cmd 'git log --color=always --graph --pretty=format:"%C(bold blue)%h%C(reset) - %C(cyan)%<(12,trunc)%cr%C(reset) %C(dim normal)[%an]%C(reset) %C(yellow)%d%C(reset) %C(normal)%s%C(reset)" {}'

    # Use fzf to select branch
    set branch (printf '%s\n' $branches | fzf --height=20 --reverse --prompt="Git Branch> " --preview=$preview_cmd)

    # If branch selected, insert at current commandline position
    if test -n "$branch"
        commandline -i "$branch"
    end

    commandline -f repaint
end
