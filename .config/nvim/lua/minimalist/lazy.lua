-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ---------------------------------------------------------------------------------------------------------------------
-- Plugins setup
-- ---------------------------------------------------------------------------------------------------------------------

local treesitter_parsers = require("minimalist.constants").treesitter_parsers

require("lazy").setup({
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				preset = "helix",
			})
			local keymaps = require("minimalist.keymaps")
			keymaps.setup()
			keymaps.setup_lazy_module_keymaps()
		end,
	},
	{
		"ibhagwan/fzf-lua",
		config = function()
			require("fzf-lua").register_ui_select()
			require("fzf-lua").setup({
				winopts = {
					fullscreen = true,
				},
				grep = {
					hidden = true,
				},
				colorschemes = {
					winopts = {
						fullscreen = false,
					},
				},
				marks = {
					winopts = {
						fullscreen = false,
					},
				},
				fzf_colors = true,
			})
		end,
	},
	{
		"stevearc/oil.nvim",
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
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		branch = "master",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				auto_install = true,
				highlight = {
					enable = true,
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				rainbow = {
					enable = true,
					extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
					max_file_lines = nil, -- Do not enable for files with more than n lines, int
				},
				autotag = {
					enable = true,
					filetype = treesitter_parsers,
				},
				-- INFO: use `o` to jump between either ends of selection for inc/dec selection w/ j,k
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn", -- set to `false` to disable one of the mappings
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				ensure_installed = {},
				ignore_install = {},
				modules = {},
				sync_install = false,
				parser_install_dir = nil,
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
	"numToStr/Comment.nvim",
	{
		"mbbill/undotree",
		config = function()
			require("minimalist.options").setup_undodir_opts()
		end,
	},
	"ggandor/leap.nvim",
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				multiline_threshold = 5, -- Maximum number of lines to show for a single context
			})
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			require("minimalist.lsp").setup()
		end,
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
		},

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "none",
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<C-y>"] = { "select_and_accept", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback_to_mappings" },
				["<C-n>"] = { "select_next", "show", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },

				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- (Default) Only show the documentation popup when manually triggered
				documentation = { auto_show = true },
				list = { selection = { auto_insert = true, preselect = false } },
				accept = { auto_brackets = { enabled = false } },
				menu = { auto_show = true },
			},

			cmdline = {
				completion = {
					list = { selection = { auto_insert = true, preselect = false } },
					menu = { auto_show = true },
				},
				keymap = {
					["<Down>"] = { "select_next", "fallback" },
					["<Up>"] = { "select_prev", "fallback" },
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					sql = { "dadbod" },
				},
				providers = {
					dadbod = { module = "vim_dadbod_completion.blink" },
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },

			signature = { enabled = true },

			snippets = { preset = "luasnip" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		build = "make install_jsregexp",
		lazy = true,
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
				end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		config = function()
			-- Load snippets from ~/.config/nvim/snippets
			require("snippets")
			-- Setup luasnip keymaps
			require("minimalist.keymaps").setup_luasnip_keymaps()
		end,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					css = { "biome", "prettierd", stop_after_first = true },
					javascript = { "biome", "prettierd", stop_after_first = true },
					javascriptreact = { "biome", "prettierd", stop_after_first = true },
					typescript = { "biome", "prettierd", stop_after_first = true },
					typescriptreact = { "biome", "prettierd", stop_after_first = true },
					json = { "biome", "prettierd", stop_after_first = true },
					jsonc = { "biome", "prettierd", stop_after_first = true },
					sh = { "shfmt" },
					yaml = { "yamlfmt" },
					rust = { "rustfmt" },
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				rust = { "clippy" },
				css = { "biomejs" },
				javascript = { "biomejs" },
				javascriptreact = { "biomejs" },
				typescript = { "biomejs" },
				typescriptreact = { "biomejs" },
				json = { "biomejs" },
			}
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "󰍵" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "│" },
				},
				signs_staged = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "󰍵" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "│" },
				},
			})
		end,
	},
	-- {
	-- 	"Exafunction/windsurf.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	config = function()
	-- 		require("codeium").setup({
	-- 			enable_cmp_source = false,
	-- 			virtual_text = {
	-- 				enabled = true,
	-- 				manual = true,
	-- 				key_bindings = {
	-- 					-- Accept the current completion.
	-- 					accept = "<M-y>",
	-- 					-- Accept the next word.
	-- 					accept_word = "<M-w>",
	-- 					-- Accept the next line.
	-- 					accept_line = "<M-cr>",
	-- 					-- Clear the virtual text.
	-- 					clear = "<M-c>",
	-- 					-- Cycle to the next completion.
	-- 					next = "<M-[>",
	-- 					-- Cycle to the previous completion.
	-- 					prev = "<M-]>",
	-- 				},
	-- 			},
	-- 			workspace_root = {
	-- 				use_lsp = true,
	-- 			},
	-- 		})
	-- 		require("minimalist.keymaps").setup_codeium_keymaps()
	-- 	end,
	-- },
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<M-y>",
					clear_suggestion = "<M-c>",
					accept_word = "<M-w>",
				},
			})
		end,
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "TSJToggle",
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
			})
		end,
	},
	{
		"echasnovski/mini.indentscope",
		config = function()
			require("mini.indentscope").setup({
				draw = {
					delay = 0,
					animation = require("mini.indentscope").gen_animation.none(),
				},
				symbol = "╎",
				mappings = {
					-- Textobjects
					object_scope = "ii",
					object_scope_with_border = "ai",

					-- Motions (jump to respective border line; if not present - body line)
					goto_top = "[i",
					goto_bottom = "]i",
				},
			})
		end,
	},
	{
		"echasnovski/mini.surround",
		opts = {
			mappings = {
				add = "ms", -- Add surrounding in Normal and Visual modes
				delete = "md", -- Delete surrounding
				find = "mf", -- Find surrounding (to the right)
				find_left = "mF", -- Find surrounding (to the left)
				highlight = "mh", -- Highlight surrounding
				replace = "mr", -- Replace surrounding
				update_n_lines = "mn", -- Update `n_lines`
			},
		},
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = function()
			require("mini.pairs").setup()
		end,
	},
	"tpope/vim-unimpaired",
	{
		"arnamak/stay-centered.nvim",
		config = function()
			require("stay-centered").setup()
		end,
	},
	-- Rust
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false, -- This plugin is already lazy
		config = function()
			require("minimalist.lsp").setup_rustaceanvim()
			require("minimalist.keymaps").setup_rustaceanvim_keymaps()
		end,
	},
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup()
		end,
	},
	-- Debug adapters setup
	{
		"igorlfs/nvim-dap-view",
		lazy = true,
		dependencies = {
			{
				"mfussenegger/nvim-dap",
				config = function()
					require("minimalist.keymaps").setup_dap_keymaps()
					require("minimalist.dap-adapters").setup()
				end,
			},
		},
		---@module 'dap-view'
		---@type dapview.Config
		opts = {},
		config = function()
			require("minimalist.keymaps").setup_dapview_keymaps()
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = true,
		config = function()
			require("neotest").setup({
				adapters = {
					require("rustaceanvim.neotest"),
				},
			})
			require("minimalist.keymaps").setup_test_keymaps()
		end,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion" }, -- Optional
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{ "j-hui/fidget.nvim", tag = "*", opts = {} },
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		lazy = true,
		config = function()
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})

			require("minimalist.options").setup_fold_opts()
			require("minimalist.keymaps").setup_fold_keymaps()
		end,
	},
	{ "godlygeek/tabular" },
	{ "tpope/vim-fugitive" },
	{ "sindrets/diffview.nvim", lazy = true },
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "/vaults/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/vaults/*.md",
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "~/vaults/personal",
				},
				{
					name = "work",
					path = "~/vaults/work",
				},
			},
			ui = {
				checkboxes = {
					[" "] = { char = "󰄱", hl_group = "ObsidianTodo" }, -- to-do
					["x"] = { char = "", hl_group = "ObsidianDone" }, -- done
					["/"] = { char = "󱎖", hl_group = "ObsidianInProgress" }, -- incomplete
					["-"] = { char = "", hl_group = "ObsidianCanceled" }, -- canceled
					[">"] = { char = "󰒊", hl_group = "ObsidianForwarded" }, -- forwarded
					["<"] = { char = "", hl_group = "ObsidianScheduling" }, -- scheduling
					["?"] = { char = "", hl_group = "ObsidianQuestion" }, -- question
					["!"] = { char = "", hl_group = "ObsidianImportant" }, -- important
					["*"] = { char = "", hl_group = "ObsidianStar" }, -- star
					["\""] = { char = "", hl_group = "ObsidianQuote" }, -- quote
					["l"] = { char = "", hl_group = "ObsidianLocation" }, -- location
					["B"] = { char = "", hl_group = "ObsidianBookmark" }, -- bookmark
					["i"] = { char = "", hl_group = "ObsidianInformation" }, -- information
					["S"] = { char = "", hl_group = "ObsidianSavings" }, -- savings
					["I"] = { char = "", hl_group = "ObsidianIdea" }, -- idea
					["p"] = { char = "", hl_group = "ObsidianPros" }, -- pros
					["c"] = { char = "", hl_group = "ObsidianCons" }, -- cons
					["f"] = { char = "󰈸", hl_group = "ObsidianFire" }, -- fire
					["k"] = { char = "", hl_group = "ObsidianKey" }, -- key
					["u"] = { char = "󰔵", hl_group = "ObsidianUp" }, -- up
					["d"] = { char = "󰔳", hl_group = "ObsidianDown" }, -- down
					["b"] = { char = "󰥪", hl_group = "ObsidianBacklog" }, -- backlog
					["."] = { char = "󱄵", hl_group = "ObsidianCarriedOver" }, -- carried over
					["t"] = { char = "", hl_group = "ObsidianBrainstorm" }, -- brainstorm
					["D"] = { char = "󰭹", hl_group = "ObsidianDiscussion" }, -- discusstion needed
				},
				hl_groups = {
					-- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
					ObsidianTodo = { bold = true, fg = "#f78c6c" },
					ObsidianDone = { bold = true, fg = "#89ddff" },
					ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
					ObsidianTilde = { bold = true, fg = "#ff5370" },
					ObsidianImportant = { bold = true, fg = "#d73128" },
					ObsidianInProgress = { bold = true, fg = "#ffcb6b" },
					ObsidianBacklog = { bold = true, fg = "#82aaff" },
					ObsidianCarriedOver = { bold = true, fg = "#c792ea" },
					ObsidianBrainstorm = { bold = true, fg = "#e0af68" },
					ObsidianDiscussion = { bold = true, fg = "#ff9e64" },
					ObsidianBullet = { bold = true, fg = "#89ddff" },
					ObsidianRefText = { underline = true, fg = "#c792ea" },
					ObsidianExtLinkIcon = { fg = "#c792ea" },
					ObsidianTag = { italic = true, fg = "#89ddff" },
					ObsidianBlockID = { italic = true, fg = "#89ddff" },
					ObsidianHighlightText = { bg = "#75662e" },
					ObsidianCanceled = { bold = true, fg = "#676e95" },
					ObsidianForwarded = { bold = true, fg = "#82aaff" },
					ObsidianScheduling = { bold = true, fg = "#ffcb6b" },
					ObsidianQuestion = { bold = true, fg = "#c3e88d" },
					ObsidianStar = { bold = true, fg = "#ffc777" },
					ObsidianQuote = { bold = true, fg = "#f07178" },
					ObsidianLocation = { bold = true, fg = "#ff9cac" },
					ObsidianBookmark = { bold = true, fg = "#bb9af7" },
					ObsidianInformation = { bold = true, fg = "#7dcfff" },
					ObsidianSavings = { bold = true, fg = "#9ece6a" },
					ObsidianIdea = { bold = true, fg = "#e0af68" },
					ObsidianPros = { bold = true, fg = "#73daca" },
					ObsidianCons = { bold = true, fg = "#f7768e" },
					ObsidianFire = { bold = true, fg = "#ff757f" },
					ObsidianKey = { bold = true, fg = "#ffc777" },
					ObsidianUp = { bold = true, fg = "#9ece6a" },
					ObsidianDown = { bold = true, fg = "#f7768e" },
				},
			},
		},
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"ThePrimeagen/harpoon",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("harpoon").setup({
				global_settings = {
					save_on_change = true,
					mark_branch = true,
				},
			})
			require("minimalist.keymaps").setup_harpoon_keymaps()
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
			custom_highlights = function(colors)
				return {
					-- CursorLine = { bg = "#2a2b3d" },
					-- CursorColumn = { bg = "#2a2b3d" },
					-- 	ColorColumn = { bg = "#313244" },
					-- 	Whitespace = { fg = "NvimDarkGray4" },
				}
			end,
		},
	},
	{ "EdenEast/nightfox.nvim", name = "nightfox", lazy = true },
	{ "rose-pine/neovim", name = "rosepine", lazy = true },
	{ "projekt0n/github-nvim-theme", name = "github-theme", lazy = true },
}, {})
