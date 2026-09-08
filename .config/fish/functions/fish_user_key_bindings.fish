function fish_user_key_bindings
	fzf --fish | source
	bind -M insert alt-b _fzf_search_git_branch
	bind -M insert alt-r _fzf_search_git_remote_branch
	bind -M insert alt-n _fzf_search_npm_scripts
	bind -M insert alt-k sesh_load_worktree
	bind -M insert alt-j _fzf_search_just_commands
end
