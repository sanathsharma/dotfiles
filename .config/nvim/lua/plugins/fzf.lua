return {
	{
		"ibhagwan/fzf-lua",
		config = function()
			-- See https://github.com/ibhagwan/fzf-lua/tree/main?tab=readme-ov-file#default-options for more supported config
			local actions = require("fzf-lua.actions")
			require("fzf-lua").setup({
				-- fzf_bin = "sk",
				-- fzf_opts = { ["--wrap"] = true },
				files = {
					actions = {
						["ctrl-e"] = { actions.toggle_ignore },
					},
				},
				grep = {
					rg_glob = true,
					-- first returned string is the new search query
					-- second returned string are (optional) additional rg flags
					-- @return string, string?
					rg_glob_fn = function(query, opts)
						local regex, flags = query:match("^(.-)%s%-%-(.*)$")
						-- If no separator is detected will return the original query
						return (regex or query), flags
					end,
					rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --with-filename -e",
					actions = {
						-- actions inherit from 'actions.files' and merge
						-- this action toggles between 'grep' and 'live_grep'
						["ctrl-e"] = { actions.grep_lgrep },
						["ctrl-r"] = { actions.toggle_ignore },
					},
				},
				winopts = {
					preview = {
						wrap = "wrap",
					},
				},
				defaults = {
					git_icons = false,
					file_icons = false,
					color_icons = false,
					-- formatter = "path.filename_first",
				},
			})
			require("fzf-lua").register_ui_select()
		end,
	},
}
