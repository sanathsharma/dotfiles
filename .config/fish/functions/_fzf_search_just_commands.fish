function _fzf_search_just_commands
	# Check for justfile in current directory first
	set justfile_paths "./justfile" "./.justfile" "./Justfile"

	set found_justfile ""
	for path in $justfile_paths
		if test -f $path
			set found_justfile $path
			break
		end
	end

	if test -z "$found_justfile"
		# If not found, try to get git toplevel directory
		if git rev-parse --git-dir >/dev/null 2>&1
			set git_toplevel (git rev-parse --show-toplevel)
			for path in ./justfile ./.justfile ./Justfile
				if test -f "$git_toplevel/$path"
					set found_justfile "$git_toplevel/$path"
					break
				end
			end
		end
	end

	# Check if justfile exists
	if test -z "$found_justfile"
		echo "No justfile found in current directory or git toplevel directory." >&2
		return 1
	end

	# Check if just is installed
	if not command -v just >/dev/null
		echo "Error: 'just' command not found. Please install just." >&2
		return 1
	end

	# Extract just recipes from justfile
	# just --list output format: "Available recipes:\n<recipe_name>[ <description>]"
	set recipes_raw (just --justfile $found_justfile --list 2>/dev/null)
	set recipes
	for line in $recipes_raw
		set line_trimmed (string trim $line)
		if test -z "$line_trimmed"
			continue
		end
		if string match -q 'Available recipes:*' $line_trimmed
			continue
		end
		set first_word (string split -m 1 ' ' $line_trimmed)[1]
		set recipes $recipes $first_word
	end

	if test (count $recipes) -eq 0
		echo "No just recipes found in justfile." >&2
		return 1
	end

	# Create preview command to show recipe content
	set preview_cmd "just --justfile $found_justfile --show {} 2>/dev/null"

	# Use fzf to select just recipe
	set selected_recipe (printf '%s\n' $recipes | fzf --height=15 --reverse --prompt="Just Recipe> " --preview=$preview_cmd)

	# If recipe selected, insert "just <recipe>" at current commandline position
	if test -n "$selected_recipe"
		commandline -i "just $selected_recipe"
	end

	commandline -f repaint
end
