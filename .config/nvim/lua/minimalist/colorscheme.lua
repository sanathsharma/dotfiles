local M = {}

function M.setup()
	require("catppuccin").setup({
		flavour = "mocha",
		integrations = {
			flash = true,
			fzf = true,
			gitsigns = true,
			indent_blankline = { enabled = true },
			leap = true,
			mini = true,
			native_lsp = {
				enabled = true,
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			snacks = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
		},
		---@diagnostic disable-next-line: unused-local
		custom_highlights = function(colors)
			return {
				CursorLine = { bg = "#2a2b3d" },
				CursorColumn = { bg = "#2a2b3d" },
				ColorColumn = { bg = "#2a2b3d" },
				-- ColorColumn = { bg = "#313244" },
				-- Whitespace = { fg = "NvimDarkGray4" },
			}
		end,
	})
end

function M.set_colorscheme()
	vim.cmd.colorscheme("catppuccin-mocha")
end

return M
