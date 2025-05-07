-- Inspiration: https://github.com/benfrain/neovim/blob/main/lua/setup/lualine.lua

local mode_map = {
	["NORMAL"] = "N",
	["O-PENDING"] = "N?",
	["INSERT"] = "I",
	["VISUAL"] = "V",
	["V-BLOCK"] = "VB",
	["V-LINE"] = "VL",
	["V-REPLACE"] = "VR",
	["REPLACE"] = "R",
	["COMMAND"] = "C",
	["SHELL"] = "SH",
	["TERMINAL"] = "T",
	["EX"] = "X",
	["S-BLOCK"] = "SB",
	["S-LINE"] = "SL",
	["SELECT"] = "S",
	["CONFIRM"] = "Y?",
	["MORE"] = "M",
}

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local function place()
	local colPre = "C:"
	local col = "%c"
	local linePre = " L:"
	local line = "%l/%L"
	return string.format("%s%s%s%s", colPre, col, linePre, line)
end

local function window()
	return vim.api.nvim_win_get_number(0)
end

return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
			icons = {},
		},
	},
	{
		"catppuccin/nvim",
		lazy = true,
		name = "catppuccin",
		opts = {
			flavour = "mocha",
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				dashboard = true,
				flash = true,
				fzf = true,
				grug_far = true,
				gitsigns = true,
				headlines = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				leap = true,
				lsp_trouble = true,
				mason = true,
				markdown = true,
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
				navic = { enabled = true, custom_bg = "lualine" },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				semantic_tokens = true,
				snacks = true,
				telescope = true,
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
	{ "folke/trouble.nvim", enabled = false },
	{ "akinsho/bufferline.nvim", enabled = false },
	{ "folke/ts-comments.nvim", enabled = false },
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = { enabled = false },
			-- explorer = { enabled = false },
			indent = { enabled = false },
		},
		config = function()
			require("snacks").scroll.disable()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- local custom_auto = require("lualine.themes.auto")
			-- custom_auto.normal.c.bg = "#1e1e2e" -- catppuccin color

			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
					component_separators = { " ", " " },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {},
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(s)
								return mode_map[s] or s
							end,
						},
					},
					lualine_b = {
						{
							"branch",
							fmt = function(str)
								local max_length = vim.o.columns / 3.5
								if string.len(str) > max_length then
									return str:sub(1, max_length) .. "..."
								end
								return str
							end,
							icon = "󰘬",
						},
						{
							"diff",
							colored = true,
							source = diff_source,
							diff_color = {
								color_added = "#a7c080",
								color_modified = "#ffdf1b",
								color_removed = "#ff6666",
							},
						},
						"diagnostics",
					},
					lualine_c = {
						{
							"filename",
							file_status = true,
							path = 1,
							shorting_target = 40,
							symbols = {
								modified = "[+]", -- Text to show when the file is modified.
								readonly = "[R]", -- Text to show when the file is non-modifiable or readonly.
								unnamed = "[No Name]", -- Text to show for unnamed buffers.
								newfile = "[New]", -- Text to show for new created file before first writting
							},
						},
						{
							"searchcount",
						},
						{
							"selectioncount",
						},
					},
					lualine_x = {
						{
							require("noice").api.status.mode.get,
							cond = require("noice").api.status.mode.has,
						},
						"rest",
						"filetype",
						{
							"fileformat",
							icons_enabled = true,
							symbols = {
								unix = "LF",
								dos = "CRLF",
								mac = "CR",
							},
						},
					},
					lualine_y = { "progress" },
					lualine_z = {
						{ place, padding = { left = 1, right = 1 } },
						{
							function()
								return os.date("%R")
							end,
						},
					},
				},
				inactive_sections = {
					lualine_a = { { window, color = { fg = "#26ffbb", bg = "#282828" } } },
					lualine_b = {
						{
							"diff",
							source = diff_source,
							color_added = "#a7c080",
							color_modified = "#ffdf1b",
							color_removed = "#ff6666",
						},
					},
					lualine_c = {
						{
							"filename",
							path = 1,
							shorting_target = 40,
							symbols = {
								modified = "[+]", -- Text to show when the file is modified.
								readonly = "[R]", -- Text to show when the file is non-modifiable or read only.
								unnamed = "[No Name]", -- Text to show for unnamed buffers.
								newfile = "[New]", -- Text to show for new created file before first writing
							},
						},
					},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {
						{ place, padding = { left = 1, right = 1 } },
						{
							function()
								return os.date("%R")
							end,
						},
					},
				},
				extensions = { "lazy", "fzf" },
			})
		end,
	},
	{
		"folke/which-key.nvim",
		icons = {
			mappings = false,
			keys = {},
		},
	},
	{
		"folke/noice.nvim",
		opts = {
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
			notify = {
				enabled = true,
				view = "mini",
			},
			messages = {
				enabled = true,
				view = "mini",
				view_error = "mini", -- view for errors
				view_warn = "mini", -- view for warnings
			},
		},
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
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
					["<C-c>"] = { "actions.close", mode = "n" },
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
				columns = {},
			})

			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
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
		"folke/flash.nvim",
		event = "VeryLazy",
		vscode = true,
		---@type Flash.Config
		opts = {},
		keys = {
			{
				"gw",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o", "x" },
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
		},
		config = function()
			vim.keymap.del("n", "s")
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
	},
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		build = (not LazyVim.is_win())
				and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
			or nil,
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
				end,
			},
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
				history = true,
				delete_check_events = "TextChanged",
			})

			LazyVim.cmp.actions.snippet_forward = function()
				if require("luasnip").jumpable(1) then
					vim.schedule(function()
						require("luasnip").jump(1)
					end)
					return true
				end
			end
			LazyVim.cmp.actions.snippet_stop = function()
				if require("luasnip").expand_or_jumpable() then -- or just jumpable(1) is fine?
					require("luasnip").unlink_current()
					return true
				end
			end

			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				end
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				end
			end, { silent = true })

			-- Lazy load snippets
			require("snippets")
		end,
	},
	{
		"saghen/blink.cmp",
		optional = true,
		opts = {
			snippets = {
				preset = "luasnip",
			},
		},
	},
	{
		"echasnovski/mini.surround",
		keys = function(_, keys)
			-- Populate the keys based on the user's options
			local opts = LazyVim.opts("mini.surround")
			print(opts.mappings.add)
			local mappings = {
				{ opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
				{ opts.mappings.delete, desc = "Delete Surrounding" },
				{ opts.mappings.find, desc = "Find Right Surrounding" },
				{ opts.mappings.find_left, desc = "Find Left Surrounding" },
				{ opts.mappings.highlight, desc = "Highlight Surrounding" },
				{ opts.mappings.replace, desc = "Replace Surrounding" },
				{ opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
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
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = false },
		},
	},
}
