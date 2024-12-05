return {
	{
		"saghen/blink.cmp",
		lazy = false, -- lazy loading handled internally
		-- optional: provides snippets for the snippet source
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				after = "blink.cmp",
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
					-- `friendly-snippets` contains a variety of pre-made snippets.
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
					require("luasnip.loaders.from_vscode").lazy_load({
						exclude = { "gitcommit" },
					})
					-- Lazy load project local snippets
					local util = require("utils.find-code-snippet-paths")
					local files = util.find_code_snippets_paths(vim.fn.getcwd() .. "/.vscode/")
					for _, file in ipairs(files or {}) do
						require("luasnip.loaders.from_vscode").load_standalone({
							path = file,
						})
					end
					-- Load custom snippets
					-- require("luasnip.loaders.from_lua").load({ paths = { "~/snippets" } })
					require("snippets")

					--#region -- Luasnip keymap's
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
					--#endregion -- Luasnip keymaps
				end,
			},
			"saadparwaiz1/cmp_luasnip",
			-- lock compat to tagged versions, if you've also locked blink.cmp to tagged versions
			{ "saghen/blink.compat", version = "*", opts = { impersonate_nvim_cmp = true } },
		},

		-- use a release tag to download pre-built binaries
		version = "v0.*",
		-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- see the "default configuration" section below for full documentation on how to define
			-- your own keymap.
			keymap = { preset = "default" },

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, via `opts_extend`
			sources = {
				completion = {
					enabled_providers = { "lsp", "path", "snippets", "buffer", "luasnip", "lazydev", --[[ "dadbod"  ]]},
				},
				providers = {
					-- dont show LuaLS require statements when lazydev has items
					lsp = { fallback_for = { "lazydev" } },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
					luasnip = {
						name = "luasnip",
						module = "blink.compat.source",

						score_offset = -3,

						opts = {
							use_show_condition = false,
							show_autosnippets = true,
						},
					},
					-- dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				},
			},
			completion = {
				menu = {
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { --[[ "kind_icon", gap = 1, ]] "kind" } },
					},
					ghost_text = {
						enabled = true,
					},
				},
			},
			snippets = {
				expand = function(snippet)
					require("luasnip").lsp_expand(snippet)
				end,
				active = function(filter)
					if filter and filter.direction then
						return require("luasnip").jumpable(filter.direction)
					end
					return require("luasnip").in_snippet()
				end,
				jump = function(direction)
					require("luasnip").jump(direction)
				end,
			},

			-- experimental signature help support
			-- signature = { enabled = true }
			highlight = {
				use_nvim_cmp_as_default = true,
			},
			windows = {
				autocomplete = {
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", gap = 1, "kind" } },
					},
				},
			},
		},
		-- allows extending the enabled_providers array elsewhere in your config
		-- without having to redefine it
		opts_extend = { "sources.completion.enabled_providers" },
	},
}
