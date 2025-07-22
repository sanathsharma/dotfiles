-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"folke/which-key.nvim",
		config = function()
			local wk = require("which-key")
			wk.setup({
				preset = "helix"
			})
			wk.add({
				{
					mode = { "n" },
					-- FzfLua
					{ "<leader>f",        "<cmd>FzfLua files<cr>",                     desc = "Open file picker" },
					{ "<leader><leader>", "<cmd>FzfLua files<cr>",                     desc = "Open file picker" },
					{ "<leader>'",        "<cmd>FzfLua resume<cr>",                    desc = "Open last picker" },
					{ "<leader>s",        "<cmd>FzfLua lsp_document_symbols<cr>",      desc = "Open symbol picker" },
					{ "<leader>S",        "<cmd>FzfLua lsp_workspace_symbols<cr>",     desc = "Open workspace symbol picker" },
					{ "<leader>d",        "<cmd>FzfLua lsp_document_diagnostics<cr>",  desc = "Open diagnostic picker" },
					{ "<leader>D",        "<cmd>FzfLua lsp_workspace_diagnostics<cr>", desc = "Open workspace diagnostic picker" },
					{ "<leader>o",        "<cmd>FzfLua lsp_incoming_calls<cr>",        desc = "Open incoming calls picker" },
					{ "<leader>O",        "<cmd>FzfLua lsp_outgoing_calls<cr>",        desc = "Open outgoing calls picker" },
					{ "<leader>a",        "<cmd>FzfLua lsp_code_actions<cr>",          desc = "Perform code actions" },

					-- Oil
					{ "-",                "<cmd>Oil<cr>",                              desc = "Open parent directory" },

					-- Goto
					{ "gd",               "<cmd>FzfLua lsp_definitions<cr>",           desc = "Goto definition" },
					{ "gD",               "<cmd>FzfLua lsp_declarations<cr>",          desc = "Goto declaration" },
					{ "gy",               "<cmd>FzfLua lsp_typedefs<cr>",              desc = "Goto type definition" },
					{ "gr",               "<cmd>FzfLua lsp_references<cr>",            desc = "Goto references" },
					{ "gi",               "<cmd>FzfLua lsp_implementations<cr>",       desc = "Goto implementation" },
				},
				{
					mode = { "n", "v" },
					-- Goto
					{ "ge", "G", desc = "Goto last line" },
					{ "gh", "0", desc = "Goto line start" },
					{ "gl", "$", desc = "Goto line end" },
					{ "gs", "^", desc = "Goto first non-blank in line" },
				}
			})
		end
	},
	{
		"ibhagwan/fzf-lua",
		opts = {}
	},
	{
		'stevearc/oil.nvim',
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				keymaps = {
					["?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-v>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["q"] = { "actions.close", mode = "n" },
					["r"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
				},
				view_options = {
					show_hidden = true,
				},
				columns = {},
			})
		end
	},
	{
		'nvim-treesitter/nvim-treesitter',
		branch = 'main',
		build = ':TSUpdate',
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				rainbow = {
					enable = true,
					extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
					max_file_lines = nil, -- Do not enable for files with more than n lines, int
				},
				autotag = {
					enable = true,
					filetypes = {
						"html",
						"javascript",
						"typescript",
						"markdown",
					},
				},
				-- INFO: use `o` to jump between either ends of selection for inc/dec selection w/ j,k
				incremental_selection = {
					enable = true,
					keymaps = {
						-- Start selection with space + v (similar to visual mode)
						init_selection = "<M-S-l>",
						-- Grow selection outward with space + k
						node_incremental = "<M-S-l>",
						-- Grow selection to scope with space + j
						scope_incremental = "<M-S-j>",
						-- Shrink selection with space + h
						node_decremental = "<M-S-h>",
					},
				},
			})
		end,
	},
	-- Themes
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {},
	},
	{
		"catppuccin/nvim",
		lazy = true,
		name = "catppuccin",
		opts = {
			flavour = "mocha",
			integrations = {
				flash = true,
				fzf = true,
				gitsigns = true,
				indent_blankline = { enabled = true },
				leap = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				snacks = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
			custom_highlights = {
				CursorLine = { bg = "#2a2b3d" },
				CursorColumn = { bg = "#2a2b3d" },
				-- 	ColorColumn = { bg = "#313244" },
				-- 	Whitespace = { fg = "NvimDarkGray4" },
			},
		},
	},
}, {})
