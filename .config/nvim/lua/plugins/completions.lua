return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		{
			"L3MON4D3/LuaSnip",
			after = "nvim-cmp",
			build = (function()
				-- Build Step is needed for regex support in snippets.
				-- This step is not supported in many windows environments.
				-- Remove the below condition to re-enable on windows.
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				-- `friendly-snippets` contains a variety of premade snippets.
				--    See the README about individual language/framework/plugin snippets:
				--    https://github.com/rafamadriz/friendly-snippets
				"rafamadriz/friendly-snippets",
				"rust10x/rust10x-vscode",
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

				-- Lazy load snippets
				require("luasnip.loaders.from_vscode").lazy_load()
				-- Load custom snippets
				require("snippets")

				--#region -- Luasnip keymaps
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
				vim.keymap.set(
					"n",
					"<leader><leader>s",
					"<cmd>source ~/.config/nvim/lua/snippets/init.lua<CR>",
					{ silent = true }
				)
				--#endregion -- Luasnip keymaps
			end,
		},
		"saadparwaiz1/cmp_luasnip",

		-- Adds other completion capabilities.
		--  nvim-cmp does not ship with all sources by default. They are split
		--  into multiple repos for maintenance purposes.
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<tab>"] = cmp.config.disable,
			}),

			sources = cmp.config.sources({
				{
					name = "nvim_lsp",
					priority = 5,
					---@param entry cmp.Entry
					---@param ctx cmp.Context
					entry_filter = function(entry, ctx)
						if ctx.filetype ~= "sql" then
							return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
						end
					end,
				},
				{ name = "path",    priority = 4 },
				{ name = "luasnip", priority = 3 },
				{
					name = "lazydev",
					group_index = 0, -- set group index to 0 to skip loading LuaLS completions
				},
			}, {
				{ name = "buffer", keyword_length = 5, priority = 1 },
			}),

			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text",
					menu = {
						nvim_lsp = "[LSP]",
						nvim_lua = "[api]",
						path = "[path]",
						luasnip = "[snip]",
						cmdline = "[cmd]",
						buffer = "[buf]",
					},
				}),
			},

			experimental = {
				ghost_text = true,
			},
		})

		cmp.setup.filetype("sql", {
			sources = {
				{ name = "vim-dadbod-completion", priority = 3 },
				{ name = "luasnip",               priority = 2 },
			},
			{
				{ name = "buffer", keyword_length = 5, priority = 1 },
			},
		})

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
			matching = {
				disallow_symbol_nonprefix_matching = false,
			},
		})
	end,
}
