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
				fzf = true,
				dap = true,
				flash = true,
				ufo = true,
				lsp_trouble = true,
				dadbod_ui = true,
				which_key = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						warnings = { "undercurl" },
					},
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					inlay_hints = {
						background = true,
					},
				},
			},
			custom_highlights = {
				CursorLine = { bg = "#313244" },
				CursorColumn = { bg = "#313244" },
				ColorColumn = { bg = "#313244" },
				Whitespace = { fg = "NvimDarkGray4" },
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
