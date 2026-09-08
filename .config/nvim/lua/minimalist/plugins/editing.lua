return {
	{
		"numToStr/Comment.nvim",
		config = function()
			require("plugins.editing.comment").setup()
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = function()
			require("plugins.editing.flash").setup()
		end,
	},
	{
		"mbbill/undotree",
		init = function()
			require("plugins.editing.undotree").init()
		end,
		config = function()
			require("plugins.editing.undotree").setup()
		end,
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "TSJToggle",
		config = function()
			require("plugins.editing.treesj").setup()
		end,
	},
	{
		"echasnovski/mini.indentscope",
		config = function()
			require("plugins.editing.mini-indentscope").setup()
		end,
	},
	{
		"echasnovski/mini.surround",
		config = function()
			require("plugins.editing.mini-surround").setup()
		end,
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = function()
			require("plugins.editing.mini-pairs").setup()
		end,
	},
	"tpope/vim-unimpaired",
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"CKolkey/ts-node-action",
		},
		config = function()
			require("plugins.editing.none-ls").setup()
		end,
	},
}
