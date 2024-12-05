return {
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		keys = {
			{ "<leader>ff", "<cmd>FzfLua files<cr>",                 desc = "Fzf files" },
			{ "<leader>fG", "<cmd>FzfLua git_files<cr>",             desc = "Fzf git files" },
			{ "<leader>fc", "<cmd>FzfLua git_status<cr>",            desc = "Fzf modified/new files" },
			{ "<leader>fg", "<cmd>FzfLua live_grep_native<cr>",      desc = "Fzf live grep" },
			{ "<leader>fh", "<cmd>FzfLua helptags<cr>",              desc = "Fzf help tags" },
			{ "<leader>fm", "<cmd>FzfLua manpages<cr>",              desc = "Fzf manpages" },
			{ "<leader>fw", "<cmd>FzfLua grep_cword<cr>",            desc = "Fzf word under cursor" },
			{ "<leader>fi", "<cmd>FzfLua lgrep_curbuf<cr>",          desc = "Fzf current buffer only" },
			{ "<leader>fr", "<cmd>FzfLua grep_last<cr>",             desc = "Fzf resume last grep" },

			{ "<leader>bf", "<cmd>FzfLua buffers<cr>",               desc = "Fzf buffers" },

			{ "<leader>gf", "<cmd>FzfLua git_files<cr>",             desc = "Fzf git branches" },
			{ "<leader>gB", "<cmd>FzfLua git_branchs<cr>",           desc = "Fzf git branches" },
			{ "<leader>gc", "<cmd>FzfLua git_bcommits<cr>",          desc = "Fzf git buffer commits" },

			{ "<leader>lD", "<cmd>FzfLua lsp_declarations<cr>",      desc = "Fzf lsp_declarations" },
			{ "<leader>ld", "<cmd>FzfLua lsp_definitions<cr>",       desc = "Fzf lsp_definitions" },
			{ "<leader>li", "<cmd>FzfLua lsp_implementations<cr>",   desc = "Fzf lsp_implementations" },
			{ "<leader>lr", "<cmd>FzfLua lsp_references<cr>",        desc = "Fzf lsp_references" },
			{ "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>",  desc = "Fzf lsp_document_symbols" },
			{ "<leader>lw", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Fzf lsp_workspace_symbols" },
			{ "<leader>lt", "<cmd>FzfLua lsp_typedefs<cr>",          desc = "Fzf lsp_typedefs" },

			{ "<leader>as", "<cmd>FzfLua spell_suggest<cr>",         desc = "Fzf spell suggest" },

			{
				"gD",
				"<cmd>lua requrie('fzf-lua').lsp_declarations({jump_to_single_result = true})<cr>",
				desc = "Fzf lsp_declarations",
			},
			{
				"gd",
				"<cmd>lua require('fzf-lua').lsp_definitions({jump_to_single_result = true})<cr>",
				desc = "Fzf lsp_definitions",
			},
			{
				"gi",
				"<cmd>lua require('fzf-lua').lsp_implementations({jump_to_single_result = true})<cr>",
				desc = "Fzf lsp_implementations",
			},
			{
				"gr",
				"<cmd>lua require('fzf-lua').lsp_references({jump_to_single_result = true})<cr>",
				desc = "Fzf lsp_references",
			},
			{ "gs", "<cmd>FzfLua lsp_document_symbols<cr>",  desc = "Fzf lsp_document_symbols" },
			{ "gw", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Fzf lsp_workspace_symbols" },
			{
				"gt",
				"<cmd>lua require('fzf-lua').lsp_typedefs({jump_to_single_result = true})<cr>",
				desc = "Fzf lsp_typedefs",
			},

			{
				"<leader>ac",
				function()
					if vim.bo.filetype == "rust" then
						vim.cmd.RustLsp("codeAction")
					else
						-- vim.lsp.buf.code_action()
						require("fzf-lua").lsp_code_actions()
					end
				end,
				desc = "Fzf lsp code actions",
			},
		},
		-- cond = function ()
		-- 	return vim.g.vscode == nil
		-- end,
		config = function()
			-- See https://github.com/ibhagwan/fzf-lua/tree/main?tab=readme-ov-file#default-options for more supported config
			local actions = require("fzf-lua.actions")
			require("fzf-lua").setup({
				{ "max-perf" },
				-- fzf_bin = "sk",
				fzf_opts = { ["--wrap"] = true },
				files = {
					actions = {
						["ctrl-e"] = actions.toggle_ignore,
						["ctrl-q"] = actions.file_sel_to_qf,
						["ctrl-y"] = actions.file_edit_or_qf,
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
						["ctrl-y"] = actions.file_edit_or_qf,
					},
				},
				lsp = {
					code_actions = {
						actions = {
							["ctrl-y"] = actions.file_edit_or_qf,
						},
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
