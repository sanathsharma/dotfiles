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
-- Constants
-- ---------------------------------------------------------------------------------------------------------------------

local treesitter_parsers = {
	"rust",
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"toml",
	"yaml",
	"json",
	"sh",
	"lua",
	"markdown",
}

-- ---------------------------------------------------------------------------------------------------------------------
-- Plugins setup
-- ---------------------------------------------------------------------------------------------------------------------

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
					{ "<leader>f",        "<cmd>FzfLua files<cr>",                                                   desc = "Open file picker" },
					{ "<C-p>",            "<cmd>FzfLua global<cr>",                                                  desc = "Open global picker" },
					{ "<leader>.",        "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h') })<cr>", desc = "Open file picker in current buffer directory" },
					{ "<leader><leader>", "<cmd>FzfLua files<cr>",                                                   desc = "Open file picker" },
					{ "<leader>'",        "<cmd>FzfLua resume<cr>",                                                  desc = "Open last picker" },
					{ "<leader>b",        "<cmd>FzfLua buffers<cr>",                                                 desc = "Open buffer picker" },
					{ "<leader>/",        "<cmd>FzfLua grep_project<cr>",                                            desc = "Global search in workspace folder" },
					{ "<leader>j",        "<cmd>FzfLua jumps<cr>",                                                   desc = "Open jumplist picker" },
					{ "<leader>s",        "<cmd>FzfLua lsp_document_symbols<cr>",                                    desc = "Open symbol picker" },
					{ "<leader>S",        "<cmd>FzfLua lsp_workspace_symbols<cr>",                                   desc = "Open workspace symbol picker" },
					{ "<leader>d",        "<cmd>FzfLua lsp_document_diagnostics<cr>",                                desc = "Open diagnostic picker" },
					{ "<leader>D",        "<cmd>FzfLua lsp_workspace_diagnostics<cr>",                               desc = "Open workspace diagnostic picker" },
					{ "<leader>g",        "<cmd>FzfLua git_status<cr>",                                              desc = "Open changed file picker" },
					{ "<leader>o",        "<cmd>FzfLua lsp_incoming_calls<cr>",                                      desc = "Open incoming calls picker" },
					{ "<leader>O",        "<cmd>FzfLua lsp_outgoing_calls<cr>",                                      desc = "Open outgoing calls picker" },
					{ "<leader>a",        "<cmd>FzfLua lsp_code_actions<cr>",                                        desc = "Perform code actions" },
					{ "<leader>r",        vim.lsp.buf.rename,                                                        desc = "Rename symbol" },
					{ "<leader>k",        vim.lsp.buf.hover,                                                         desc = "Show docs for item under cursor" },

					-- Oil
					{ "-",                "<cmd>Oil<cr>",                                                            desc = "Open parent directory" },

					-- Split join
					{ "<leader>tt",       "<cmd>TSJToggle<CR>",                                                      desc = "Toggle split join" },

					-- Goto
					-- { "gd",               "<cmd>FzfLua lsp_definitions<cr>",                                         desc = "Goto definition" }, -- Use gri instead
					-- { "gD",               "<cmd>FzfLua lsp_declarations<cr>",                                        desc = "Goto declaration" },
					-- { "gy",               "<cmd>FzfLua lsp_typedefs<cr>",                                            desc = "Goto type definition" }, -- Use grt instead
					-- { "gr",               "<cmd>FzfLua lsp_references<cr>",                                          desc = "Goto references" }, -- Use grr instead
					-- { "gi",               "<cmd>FzfLua lsp_implementations<cr>",                                     desc = "Goto implementation" }, -- Use gri instead

					-- Git
					{ "[h",               "<cmd>Gitsigns nav_hunk prev<cr>",                                         desc = "Previous hunk" },
					{ "]h",               "<cmd>Gitsigns nav_hunk next<cr>",                                         desc = "Next hunk" },

					-- Helpers
					{ "<leader>y",        '"+yy',                                                                    desc = "Yank current line into system clipboard" },

					-- Remaps
					{ "<Esc>",            "<cmd>nohlsearch<CR>" },
					{ "n",                "nzzzv" },
					{ "N",                "Nzzzv" },
					{ "<C-d>",            "<C-d>zz" },
					{ "<C-u>",            "<C-u>zz" },
					{ "U",                "<C-r>" },

					-- Leap
					{ "gw",               "<Plug>(leap)",                                                            desc = "Leap anywhere" },
					{ "gW",               "<Plug>(leap-from-window)",                                                desc = "Leap from window" },
				},
				{
					mode = { "n", "v" },
					-- Goto
					{ "ge",        "G",   desc = "Goto last line" },
					{ "gh",        "0",   desc = "Goto line start" },
					{ "gl",        "$",   desc = "Goto line end" },
					{ "gs",        "^",   desc = "Goto first non-blank in line" },

					-- Comments
					{ "<leader>c", "gcc", desc = "Comment/uncomment selections",       noremap = true },
					{ "<leader>C", "gbc", desc = "Block comment/uncomment selections", noremap = true },
				},
				{
					mode = { "v" },
					-- Remaps
					{ ">", ">gv", noremap = true, desc = "Keep selection after right indent" },
					{ "<", "<gv", noremap = true, desc = "Keep selection after left indent" },
				},
				{
					mode = { "x", "v" },
					{ "<leader>y", '"+y', noremap = true, desc = "Yank selection into system clipboard" }
				}
			})
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
		config = function()
			-- Snippet support required for css/html completions from vscode-langservers-extracted
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			local lspconfig = require("lspconfig")

			lspconfig.cssls.setup {
				capabilities = capabilities,
			}

			lspconfig.html.setup {
				capabilities = capabilities,
			}
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
