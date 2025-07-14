function _fzf_search_git_branch
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Not a git repository."
        return 1
    end

    set branches (git branch -a | \
        sed 's/^[*+ ] //' | \
        sed 's/^remotes\///' | \
        grep -v 'HEAD' | \
        sort -u)

    set preview_cmd 'git log --color=always --graph --pretty=format:"%C(bold blue)%h%C(reset) - %C(cyan)%<(12,trunc)%cr%C(reset) %C(dim normal)[%an]%C(reset) %C(yellow)%d%C(reset) %C(normal)%s%C(reset)" {}'

    # Use fzf to select branch
    set selected_branch (printf '%s\n' $branches | fzf --height=20 --reverse --prompt="Git Branch> " --preview=$preview_cmd)

    # If branch selected, remove remote prefix and insert at current commandline position
    if test -n "$selected_branch"
        set clean_branch $selected_branch

        # Get all remotes and remove their prefixes (only at start of string)
        for remote in (git remote)
            if string match -q "$remote/*" $clean_branch
                set clean_branch (string replace "$remote/" "" $clean_branch)
                break
            end
        end

        commandline -i "$clean_branch"
    end

    commandline -f repaint
end
