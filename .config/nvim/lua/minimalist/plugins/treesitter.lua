return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		init = function()
			require("plugins.treesitter.treesitter").init()
		end,
		config = function()
			require("plugins.treesitter.treesitter").setup()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			require("plugins.treesitter.textobjects").init()
		end,
		config = function()
			require("plugins.treesitter.textobjects").setup()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("plugins.treesitter.context").setup()
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("plugins.treesitter.ts-autotag").setup()
		end,
	},
}
