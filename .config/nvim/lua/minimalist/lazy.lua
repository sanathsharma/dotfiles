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
			-- local actions = require("fzf-lua.actions")
			-- local actions_map = {
			-- -- Pickers inheriting these actions:
			-- --      files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
			-- --      tags, btags, args, buffers, tabs, lines, blines
			-- --    `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
			-- --    replace `enter` with `file_edit` to open all files/bufs whether single or multiple
			-- --    replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
			-- 	["enter"] = actions.file_edit_or_qf,
			-- 	["ctrl-s"] = actions.file_split,
			-- 	["ctrl-v"] = actions.file_vsplit,
			-- 	["ctrl-t"] = actions.file_tabedit,
			-- 	["alt-q"] = actions.file_sel_to_qf,
			-- 	["alt-Q"] = actions.file_sel_to_ll,
			-- 	["alt-i"] = actions.toggle_ignore,
			-- 	["alt-h"] = actions.toggle_hidden,
			-- 	["alt-f"] = actions.toggle_follow,
			-- }

			require("fzf-lua").register_ui_select()
			require("fzf-lua").setup({
				winopts = {
					fullscreen = true,
				},
				grep = {
					hidden = true,
				},
				files = {
					previewer = "bat",
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
			require("minimalist.keymaps").setup_fzflua_keymaps()
		end,
	},
	{
		"mikavilpas/yazi.nvim",
		version = "*", -- use the latest stable version
		event = "VeryLazy",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		---@type YaziConfig | {}
		opts = {
			open_for_directories = false,
			keymaps = {
				show_help = "<f1>",
			},
			yazi_floating_window_zindex = nil,
		},
		-- 👇 if you use `open_for_directories=true`, this is recommended
		init = function()
			-- mark netrw as loaded so it's not loaded at all.
			--
			-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
			vim.g.loaded_netrwPlugin = 1
		end,
		config = function()
			require("minimalist.keymaps").setup_yazi_keymaps()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("minimalist.treesitter").setup_autocmds()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true
		end,
		config = function()
			-- configuration
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						-- ["@parameter.outer"] = "v", -- charwise
						-- ["@function.outer"] = "V", -- linewise
						-- ['@class.outer'] = '<c-v>', -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true of false
					include_surrounding_whitespace = false,
				},
				move = {
					-- whether to set jumps in the jumplist
					set_jumps = true,
				},
			})

			require("minimalist.keymaps").setup_treesitter_textobjects_keymaps()
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("minimalist.keymaps").setup_comment_keymaps()
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = function()
			require("minimalist.keymaps").setup_flash_keymaps()
		end,
	},
	{
		"mbbill/undotree",
		config = function()
			require("minimalist.options").setup_undodir_opts()
		end,
	},
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
		dependencies = {
			"saghen/blink.cmp",
			"b0o/SchemaStore.nvim",
		},
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
			"rafamadriz/friendly-snippets",
			{ "rust10x/rust10x-vscode", ft = { "rust" } },
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		config = function()
			local luasnip = require("luasnip")
			local types = require("luasnip.util.types")

			luasnip.config.setup({
				keep_roots = true,
				link_roots = true,
				link_children = true,
				exit_roots = false,
				update_events = "TextChanged,TextChangedI",
				-- enable_autosnippets = true,
				ext_ops = {
					[types.choiceNode] = {
						active = {
							virt_text = { { "⇐", "Error" } },
						},
					},
				},
			})

			-- Load snippets from ~/.config/nvim/snippets
			require("snippets")
			-- Setup luasnip keymaps
			require("minimalist.keymaps").setup_luasnip_keymaps()

			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
		end,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					css = { "stylelint", "biome-check", "prettierd", stop_after_first = true },
					javascript = { "biome-check", "prettierd", stop_after_first = true },
					javascriptreact = { "biome-check", "prettierd", stop_after_first = true },
					typescript = { "biome-check", "prettierd", stop_after_first = true },
					typescriptreact = { "biome-check", "prettierd", stop_after_first = true },
					json = { "biome-check", "prettierd", stop_after_first = true },
					jsonc = { "biome-check", "prettierd", stop_after_first = true },
					html = { "biome-check", "prettierd", stop_after_first = true },
					sh = { "shfmt" },
					yaml = { "yamlfmt" },
					rust = { "rustfmt" },
					svelte = { "biome-check" },
					sql = { "sql_formatter" },
				},
				formatters = {
					sql_formatter = {
						meta = {
							url = "https://github.com/sql-formatter-org/sql-formatter",
							description = "A whitespace formatter for different query languages.",
						},
						command = "sql-formatter",
						args = {
							"--config",
							vim.fn.expand("~") .. "/.config/sql-formatter/sql_formatter.json",
						},
					},
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
		"cordx56/rustowl",
		version = "*",
		build = "cargo install rustowl",
		lazy = false,
		config = function()
			require("minimalist.keymaps").setup_rustowl_keymaps()
			require("rustowl").setup({
				auto_attach = true,
				auto_enable = false,
				highlight_style = "underline",
				idle_time = 500,
				colors = {
					lifetime = "#50fa7b", -- Dracula green
					imm_borrow = "#8be9fd", -- Dracula cyan
					mut_borrow = "#ff79c6", -- Dracula pink
					move = "#f1fa8c", -- Dracula yellow
					call = "#ffb86c", -- Dracula orange
					outlive = "#ff5555", -- Dracula red
				},
			})
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
		"ThePrimeagen/99",
		config = function()
			local _99 = require("99")
			local cwd = vim.uv.cwd()
			local basename = vim.fs.basename(cwd)
			local hostname = vim.uv.os_gethostname()
			local provider = _99.Providers.ClaudeCodeProvider
			local model = "claude-sonnet-4-5"

			if hostname == "pop-os" then
				provider = _99.Providers.OpenCodeProvider
				model = "opencode/minimax-m2.5"
			end

			_99.setup({
				provider = provider,
				model = model,
				logger = {
					level = _99.DEBUG,
					path = "/tmp/" .. basename .. ".99.debug",
					print_on_error = true,
				},
				tmp_dir = "./tmp",
			})
			require("minimalist.keymaps").setup_99_keymaps()
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
	-- NOTE: Run `:Obsession` to start auto save session and then run `:source Session.vim` to restore
	-- Use `:!Obsession` to stop auto save session
	"tpope/vim-obsession",
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
		config = function()
			require("dap-view").setup({
				winbar = {
					sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "sessions", "console" },
					controls = { enabled = true },
				},
				switchbuf = "useopen,usetab,uselast",
			})
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
	{ "j-hui/fidget.nvim", version = "*", opts = {} },
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
				{
					name = "work",
					path = "~/vaults/scribble",
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
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"CKolkey/ts-node-action",
		},
		config = function()
			local null_ls = require("null-ls")
			require("null-ls").setup({
				sources = {
					null_ls.builtins.code_actions.refactoring,
					null_ls.builtins.code_actions.ts_node_action,
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
			custom_highlights = function(colors)
				return {
					CursorLine = { bg = "#2a2b3d" },
					CursorColumn = { bg = "#2a2b3d" },
					ColorColumn = { bg = "#2a2b3d" },
					-- ColorColumn = { bg = "#313244" },
					-- Whitespace = { fg = "NvimDarkGray4" },
				}
			end,
		},
	},
	{ "EdenEast/nightfox.nvim", name = "nightfox", lazy = true },
	{ "rose-pine/neovim", name = "rosepine", lazy = true },
	{ "projekt0n/github-nvim-theme", name = "github-theme", lazy = true },
	-- Custom plugins
	{
		-- dir = "~/personal/scribble.nvim",
		-- dir = "~/code/scribble.nvim",
		"sanathsharma/scribble.nvim",
		config = function()
			vim.g.scribble_dir = "~/vaults/scribble"
			require("scribble").setup()
			require("minimalist.keymaps").setup_scribble_keymaps()
		end,
	},
}, {})
