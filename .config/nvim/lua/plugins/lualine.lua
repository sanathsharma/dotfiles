return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- local custom_auto = require("lualine.themes.auto")
		-- custom_auto.normal.c.bg = "#1e1e2e" -- catppuccin color

		require("lualine").setup({
			options = {
				theme = "auto",
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { {
					"mode",
					fmt = function(str)
						return str:sub(1, 1)
					end,
				} },
				lualine_b = {
					{
						"branch",
						fmt = function(str)
							local max_length = vim.o.columns / 3.5
							if string.len(str) > max_length then
								return str:sub(1, max_length) .. "..."
							end
							return str
						end,
					},
					"diff",
					"diagnostics",
				},
				lualine_c = { { "filename", file_status = true, path = 1 } },
				lualine_x = { "rest", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
