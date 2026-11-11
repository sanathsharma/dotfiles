return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("plugins.git.gitsigns").setup()
		end,
	},
	{ "sindrets/diffview.nvim", lazy = true },
}
