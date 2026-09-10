local M = {}

function M.setup()
	require("mini.ai").setup({
		custom_textobjects = {
			-- Owned by nvim-treesitter-textobjects instead (ia/aa, ib/ab, if/af)
			a = false,
			b = false,
			f = false,
		},
	})
end

return M
