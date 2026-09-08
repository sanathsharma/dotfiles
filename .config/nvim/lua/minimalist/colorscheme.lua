local M = {}

function M.setup()
	require("catppuccin").setup({
		flavour = "mocha",
		lsp_styles = {
			underlines = {
				errors = { "undercurl" },
				hints = { "underline" },
				warnings = { "undercurl" },
				information = { "underline" },
				ok = { "underline" },
			},
		},
		auto_integrations = true,
		styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
			comments = { "italic" },
			conditionals = { "italic" },
			loops = {},
			functions = { "italic" },
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = { "italic" },
			operators = {},
			-- miscs = {}, -- Uncomment to turn off hard-coded styles
		},
	})
end

function M.set_colorscheme()
	vim.cmd.colorscheme("catppuccin-mocha")
end

return M
