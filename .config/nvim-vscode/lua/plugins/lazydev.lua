return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		cond = function ()
			return vim.g.vscode == nil
		end,
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
