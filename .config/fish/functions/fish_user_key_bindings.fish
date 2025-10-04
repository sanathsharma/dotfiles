function fish_user_key_bindings
	fzf --fish | source
	bind -M insert ctrl-alt-b _fzf_search_git_branch
	bind -M insert ctrl-alt-r _fzf_search_git_remote_branch
	bind -M insert ctrl-alt-n _fzf_search_npm_scripts
	bind -M insert ctrl-alt-k tms
end
