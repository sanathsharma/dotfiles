return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "/vaults/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/vaults/*.md",
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugins.notes.obsidian").setup()
		end,
	},
}
