return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("plugins.formatting.conform").setup()
		end,
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("plugins.formatting.lint").setup()
		end,
	},
}
