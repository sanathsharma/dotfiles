return {
	{
		"echasnovski/mini.bracketed",
		version = "*",
		ft = require("utils.ft-known"),
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
		ft = require("utils.ft-known"),
	},
	{
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons", --[[ "nvim-telescope/telescope.nvim"  ]]
		},
		cmd = "Trouble",
		lazy = true,
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble close<cr>",
				desc = "Close (Trouble)",
			},
			{
				"<leader>xb",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>xs",
				"<cmd>Trouble symbols toggle focus=false new=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>xl",
				"<cmd>Trouble lsp toggle focus=false win.position=right new=false<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xo",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xq",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
			{
				"<leader>xr",
				"<cmd>Trouble lsp_references new=false<cr>",
				desc = "LSP references (Trouble)",
			},
			{
				"<leader>xD",
				"<cmd>Trouble lsp_declarations new=false<cr>",
				desc = "LSP delectrations (Trouble)",
			},
			{
				"<leader>xd",
				"<cmd>Trouble lsp_definitions new=false<cr>",
				desc = "LSP definations (Trouble)",
			},
			{
				"<leader>xi",
				"<cmd>Trouble lsp_implementations new=false<cr>",
				desc = "LSP implementations (Trouble)",
			},
			{
				"<leader>xt",
				"<cmd>Trouble lsp_type_definitions new=false<cr>",
				desc = "LSP type definations (Trouble)",
			},
			{
				"<leader>xs",
				"<cmd>Trouble lsp_document_symbols new=false<cr>",
				desc = "LSP document symbols(Trouble)",
			},
		},
		config = function()
			--[[ local open_with_trouble = require("trouble.sources.telescope").open

			require("telescope").setup({
				defaults = {
					mappings = {
						i = { ["<C-t>"] = open_with_trouble },
						n = { ["<C-t>"] = open_with_trouble },
					},
				},
			}) ]]

			require("trouble").setup({
				auto_close = false, -- auto close when there are no items
				follow = true,
				auto_refresh = false,
				focus = true,
				auto_jump = true,
				pinned = true,
			})
		end,
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = require("utils.ft-known"),
		config = function()
			require("treesj").setup()
			vim.keymap.set("n", "<leader>tt", "<cmd>TSJToggle<CR>", { desc = "Toggle split join" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		ft = require("utils.ft-known"),
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				max_lines = 10, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 5, -- Maximum number of lines to show for a single context
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})

			vim.keymap.set("n", "<leader>ts", "<cmd>TSContextToggle<CR>", { desc = "[T]oggle [s]ticky scroll" })
			vim.keymap.set("n", "<leader>xs", function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end, { silent = true, desc = "[g]o to nearest [s]tick scroll context" })

			vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = false })
			vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = false })
		end,
	},
	{
		"RRethy/vim-illuminate",
		ft = require("utils.ft-known"),
	},
	{
		"folke/twilight.nvim",
		cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		ft = require("utils.ft-known"),
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
		"windwp/nvim-autopairs",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		event = "InsertEnter",
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
		opts = {
			fast_wrap = {},
			disable_filetype = { "TelescopePrompt", "vim" },
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)

			-- setup cmp for autopairs
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					-- Defaults
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = false, -- Auto close on trailing </
				},
			})
		end,
	},
	{
		"echasnovski/mini.indentscope",
		ft = require("utils.ft-known"),
		version = "*",
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
		"folke/noice.nvim",
		event = "UIEnter",
		opts = {
			-- add any options here
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			routes = {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
			cmdline = {
				enabled = true,
				view = "cmdline",
				format = {
					cmdline = { icon = "❱" },
				},
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			-- "rcarriga/nvim-notify",
		},
	},
	-- {
	-- 	"HiPhish/rainbow-delimiters.nvim",
	-- 	event = "UIEnter",
	-- },
	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
		ft = require("utils.ft-known"),
		opts = {},
	},
	{
		"mbbill/undotree",
		ft = require("utils.ft-known"),
	},
	{
		"brenoprata10/nvim-highlight-colors",
		ft = { "jsx", "tsx", "ts", "css", "scss", "js" },
		config = function()
			require("nvim-highlight-colors").setup({
				render = "virtual", -- or 'foreground' or 'first_column'
			})
		end,
	},
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
