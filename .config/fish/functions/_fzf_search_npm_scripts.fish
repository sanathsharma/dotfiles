function _fzf_search_npm_scripts
    # Check for package.json in current directory first
    set package_json_path "./package.json"

    if not test -f $package_json_path
        # If not found, try to get git toplevel directory
        if git rev-parse --git-dir >/dev/null 2>&1
            set git_toplevel (git rev-parse --show-toplevel)
            set package_json_path "$git_toplevel/package.json"
        end
    end

    # Check if package.json exists
    if not test -f $package_json_path
        echo "No package.json found in current directory or git toplevel directory." >&2
        return 1
    end

    # Extract npm scripts from package.json
    set scripts (jq -r '.scripts | keys[]' $package_json_path 2>/dev/null)

    if test $status -ne 0
        echo "Error: Failed to parse package.json. Make sure jq is installed." >&2
        return 1
    end

    if test (count $scripts) -eq 0
        echo "No npm scripts found in package.json." >&2
        return 1
    end

    # Create preview command to show script content
    set preview_cmd "jq -r '.scripts[\"{}\"]//.scripts.\"{}\"' $package_json_path"

    # Use fzf to select npm script
    set selected_script (printf '%s\n' $scripts | fzf --height=15 --reverse --prompt="NPM Script> " --preview=$preview_cmd)

    # If script selected, insert "npm run <script>" at current commandline position
    if test -n "$selected_script"
        commandline -i "npm run $selected_script"
    end

    commandline -f repaint
end
