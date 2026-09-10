local M = {}

function M.setup()
	require("blink.cmp").setup({
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

			["<M-i>"] = { "show_signature", "hide_signature", "fallback" },
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = { auto_show = true },
			list = { selection = { auto_insert = true, preselect = false } },
			accept = { auto_brackets = { enabled = false } },
			menu = {
				auto_show = true,
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								-- customize icon for alias source
								if ctx.item.kind_name == "Alias" then
									return " "
								end
								-- fallback to default behavior
								return ctx.kind_icon .. ctx.icon_gap
							end,
						},
					},
				},
			},
			ghost_text = { enabled = true },
		},

		cmdline = {
			completion = {
				list = { selection = { auto_insert = true, preselect = false } },
				menu = { auto_show = true },
				ghost_text = { enabled = true },
			},
			keymap = {
				["<Down>"] = { "select_next", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
			},
			sources = { "buffer", "cmdline", "alias" },
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer", "ripgrep" },
			per_filetype = {
				sql = { "dadbod", "snippets" },
			},
			providers = {
				dadbod = { module = "vim_dadbod_completion.blink" },
				-- automatic mode: searches once typing passes prefix_min_len (default 3)
				ripgrep = { module = "blink-ripgrep", name = "Ripgrep", opts = {} },
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
				alias = {
					name = "Alias",
					module = "plugins.completion.sources.blink-cmp-alias", -- custom source
					opts = {
						aliases = require("plugins.completion.aliases").get(),
					},
				},
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },

		signature = {
			enabled = true,
			trigger = {
				enabled = true,
				show_on_trigger_character = true,
			},
		},

		snippets = { preset = "luasnip" },
	})
end

return M
