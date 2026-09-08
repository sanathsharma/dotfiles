return {
	{
		"folke/which-key.nvim",
		config = function()
			require("plugins.ui.which-key").setup()
		end,
	},
	{
		"j-hui/fidget.nvim",
		version = "*",
		config = function()
			require("plugins.ui.fidget").setup()
		end,
	},
}
