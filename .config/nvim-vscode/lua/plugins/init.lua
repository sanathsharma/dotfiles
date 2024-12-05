return {
	-- Catppuccin theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				integrations = {
					treesitter = true,
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							warnings = { "undercurl" },
						},
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
							ok = { "italic" },
						},
						inlay_hints = {
							background = true,
						},
					},
					which_key = true,
				},
				custom_highlights = {
					CursorLine = { bg = "#313244" },
					CursorColumn = { bg = "#313244" },
					ColorColumn = { bg = "#313244" },
					Whitespace = { fg = "NvimDarkGray4" },
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"numToStr/Comment.nvim",
		lazy = true,
		keys = {
			{ "gcc", mode = "n",          desc = "Comment toggle current line" },
			{ "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
			{ "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
			{ "gbc", mode = "n",          desc = "Comment toggle current block" },
			{ "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
			{ "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
			{
				"<leader>/",
				function()
					require("Comment.api").toggle.linewise.current()
				end,
				desc = "Toggle comment",
			},
			{
				"<leader>/",
				"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
				mode = "v",
				desc = "Toggle comment",
			},
		},
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},

	{
		"folke/flash.nvim",
		---@type Flash.Config
		opts = {
			search = {
				-- mode = "fuzzy"
			},
		},
		-- stylua: ignore
		lazy = true,
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},

	{
		"echasnovski/mini.bracketed",
		version = "*",
		-- ft = require("utils.ft-known"),
		event = "BufEnter",
		config = function()
			require("mini.bracketed").setup({
				buffer = { suffix = "b", options = {} },
				comment = { suffix = "c", options = {} },
				conflict = { suffix = "x", options = {} },
				diagnostic = { suffix = "d", options = {} },
				file = { suffix = "f", options = {} },
				indent = { suffix = "i", options = {} },
				jump = { suffix = "j", options = {} },
				location = { suffix = "l", options = {} },
				oldfile = { suffix = "o", options = {} },
				quickfix = { suffix = "q", options = {} },
				treesitter = { suffix = "n", options = {} },
				undo = { suffix = "u", options = {} },
				window = { suffix = "w", options = {} },
				yank = { suffix = "y", options = {} },
			})
		end,
	},

	{
		"tpope/vim-surround",
		-- ft = require("utils.ft-known"),
		event = "BufEnter",
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		-- ft = require("utils.ft-known"),
		event = "BufEnter",
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aj"] = "@conditional.outer",
							["ij"] = "@conditional.inner",
							["al"] = "@loop.outer",
							["il"] = "@loop.inner",
							["at"] = "@comment.outer",
							["as"] = "@scope",
						},
						include_surrounding_whitespace = false,
					},
				},
			})
		end,
	},

	{
		"echasnovski/mini.indentscope",
		-- ft = require("utils.ft-known"),
		event = "BufEnter",
		version = "*",
		cond = function()
			return vim.g.vscode == nil
		end,
		config = function()
			require("mini.indentscope").setup({
				draw = {
					delay = 0,
					animation = require("mini.indentscope").gen_animation.none(),
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		cond = function()
			return vim.g.vscode == nil
		end,
		opts = {},
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
				},
				view_options = {
					show_hidden = true,
				},
			})

			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
}
