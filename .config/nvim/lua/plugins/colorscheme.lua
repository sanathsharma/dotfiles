return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			integrations = {
				cmp = true,
				gitsigns = true,
				treesitter = true,
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
