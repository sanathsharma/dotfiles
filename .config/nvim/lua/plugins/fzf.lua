return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "folke/trouble.nvim" },
		config = function()
			-- See https://github.com/ibhagwan/fzf-lua/tree/main?tab=readme-ov-file#default-options for more supported config
			local actions = require("fzf-lua.actions")
			local open_with_trouble = require("trouble.sources.fzf").open
			require("fzf-lua").setup({
				{ "max-perf" },
				-- fzf_bin = "sk",
				fzf_opts = { ["--wrap"] = true },
				files = {
					actions = {
						["ctrl-e"] = actions.toggle_ignore,
						["ctrl-q"] = actions.file_sel_to_qf,
						["ctrl-t"] = open_with_trouble,
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
					rg_opts = " --color=never --column --line-number --no-heading --smart-case --max-columns=4096 --hidden -e",
					actions = {
						-- actions inherit from 'actions.files' and merge
						-- this action toggles between 'grep' and 'live_grep'
						["ctrl-e"] = actions.grep_lgrep,
						["ctrl-r"] = actions.toggle_ignore,
						["ctrl-q"] = {
							fn = actions.file_edit_or_qf,
							prefix = "select-all+",
						},
						["ctrl-t"] = open_with_trouble,
					},
				},
				winopts = {
					preview = {
						wrap = "wrap",
					},
				},
				keymap = {
					-- Below are the default binds, setting any value in these tables will override
					-- the defaults, to inherit from the defaults change [1] from `false` to `true`
					builtin = {
						false,          -- do not inherit from defaults
						-- neovim `:tmap` mappings for the fzf win
						["<M-Esc>"] = "hide", -- hide fzf-lua, `:FzfLua resume` to continue
						["<F1>"] = "toggle-help",
						["<F2>"] = "toggle-fullscreen",
						-- Only valid with the 'builtin' previewer
						["<F3>"] = "toggle-preview-wrap",
						["<F4>"] = "toggle-preview",
						-- Rotate preview clockwise/counter-clockwise
						["<F5>"] = "toggle-preview-ccw",
						["<F6>"] = "toggle-preview-cw",
						["<S-down>"] = "preview-page-down",
						["<S-up>"] = "preview-page-up",
						["<M-S-down>"] = "preview-down",
						["<M-S-up>"] = "preview-up",
					},
					fzf = {
						false, -- do not inherit from defaults
						-- fzf '--bind=' options
						["ctrl-z"] = "abort",
						["ctrl-u"] = "unix-line-discard",
						["ctrl-f"] = "half-page-down",
						["ctrl-b"] = "half-page-up",
						["ctrl-a"] = "beginning-of-line",
						["ctrl-e"] = "end-of-line",
						["alt-a"] = "toggle-all",
						["alt-g"] = "first",
						["alt-G"] = "last",
						-- Only valid with fzf previewers (bat/cat/git/etc)
						["f3"] = "toggle-preview-wrap",
						["f4"] = "toggle-preview",
						["shift-down"] = "preview-page-down",
						["shift-up"] = "preview-page-up",
					},
				},
			})
			require("fzf-lua").register_ui_select()
		end,
	},
}
