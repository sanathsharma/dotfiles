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
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						warnings = { "undercurl" },
					},
				},
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
