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

-- ---------------------------------------------------------------------------------------------------------------------
-- Plugins setup
-- ---------------------------------------------------------------------------------------------------------------------

local treesitter_parsers = require("minimalist.constants").treesitter_parsers

require("lazy").setup({
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				preset = "helix"
			})
			require("minimalist.keymaps").setup()
		end
	},
	{
		"ibhagwan/fzf-lua",
		opts = {
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
		},
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
	--[[ {
		'nvim-treesitter/nvim-treesitter',
		branch = 'main',
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter').setup()
			require('nvim-treesitter').install(treesitter_parsers)
			vim.api.nvim_create_autocmd('FileType', {
				pattern = treesitter_parsers,
				callback = function()
					-- syntax highlighting, provided by Neovim
					vim.treesitter.start()
					-- folds, provided by Neovim
					vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
					-- indentation, provided by nvim-treesitter
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	} ]] --,
	{
		'nvim-treesitter/nvim-treesitter',
		branch = 'master',
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
					filetype = treesitter_parsers,
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
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
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
	'numToStr/Comment.nvim',
	"mbbill/undotree",
	"tpope/vim-unimpaired",
	"ggandor/leap.nvim",
	{
		"neovim/nvim-lspconfig",
		dependencies = { 'saghen/blink.cmp' },
		config = function()
			require("minimalist.lsp").setup()
		end
	},
	{
		'saghen/blink.cmp',
		-- optional: provides snippets for the snippet source
		dependencies = {
			{ 'L3MON4D3/LuaSnip', version = 'v2.*' },
		},

		-- use a release tag to download pre-built binaries
		version = '1.*',
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
			keymap = { preset = 'default' },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = 'mono'
			},

			completion = {
				-- (Default) Only show the documentation popup when manually triggered
				documentation = { auto_show = false },
				list = { selection = { auto_insert = false, preselect = false } },
				accept = { auto_brackets = { enabled = false }, },
				menu = { auto_show = false },
			},

			cmdline = {
				completion = {
					list = { selection = { auto_insert = false, preselect = false } },
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },

			signature = { enabled = true },

			snippets = { preset = 'luasnip' },
		},
		opts_extend = { "sources.default" }
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
		end
	},
	{
		'stevearc/conform.nvim',
		config = function()
			require('conform').setup({
				formatters_by_ft = {
					lua = { 'stylua' },
					css = { 'biome' },
					javascript = { 'biome' },
					javascriptreact = { 'biome' },
					typescript = { 'biome' },
					typescriptreact = { 'biome' },
					json = { 'biome' },
					sh = { 'shfmt' },
					yaml = { 'yamlfmt' },
					rust = { 'rustfmt' },
				}
			})
		end
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup {
				signs        = {
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
			}
		end
	},
	{
		"Exafunction/windsurf.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("codeium").setup({
				enable_cmp_source = false,
				virtual_text = {
					enabled = true
				},
				workspace_root = {
					use_lsp = true,
				},
			})
		end
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup()
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
				add = "ms",        -- Add surrounding in Normal and Visual modes
				delete = "md",     -- Delete surrounding
				find = "mf",       -- Find surrounding (to the right)
				find_left = "mF",  -- Find surrounding (to the left)
				highlight = "mh",  -- Highlight surrounding
				replace = "mr",    -- Replace surrounding
				update_n_lines = "mn", -- Update `n_lines`
			},
		},
	},
	"mfussenegger/nvim-dap",
	{
		'mrcjkb/rustaceanvim',
		version = '^6',
		lazy = false, -- This plugin is already lazy
		config = function()
			require("minimalist.lsp").setup_rustaceanvim()
			require("minimalist.keymaps").setup_rustaceanvim_keymaps()
		end,
	},
	{
		'saecki/crates.nvim',
		event = { "BufRead Cargo.toml" },
		config = function()
			require('crates').setup()
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
