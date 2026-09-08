return {
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
		config = function()
			require("plugins.completion.blink").setup()
		end,
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
		config = function()
			require("plugins.completion.luasnip").setup()
		end,
	},
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("plugins.completion.supermaven").setup()
		end,
	},
}
