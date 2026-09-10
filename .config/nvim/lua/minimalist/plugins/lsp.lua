return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"b0o/SchemaStore.nvim",
		},
		config = function()
			require("plugins.lsp.lspconfig").setup()
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
		"mrcjkb/rustaceanvim",
		version = "^9",
		lazy = false, -- This plugin is already lazy
		config = function()
			require("plugins.lsp.rustaceanvim").setup_rustaceanvim()
			require("plugins.lsp.rustaceanvim").setup()
		end,
	},
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("plugins.lsp.crates").setup()
		end,
	},
	{
		"cordx56/rustowl",
		version = "*",
		build = "cargo install rustowl",
		lazy = false,
		config = function()
			require("plugins.lsp.rustowl").setup()
		end,
	},
	{
		"rachartier/tiny-code-action.nvim",
		-- no `version` -- upstream cuts no tags, so a version constraint matches
		-- nothing and the install may not track latest main reliably
		dependencies = { "ibhagwan/fzf-lua" },
		event = "LspAttach",
		config = function()
			require("plugins.lsp.tiny-code-action").setup()
		end,
	},
}
