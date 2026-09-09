local M = {}

function M.setup()
	require("nvim-ts-autotag").setup({
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = false, -- Auto close on trailing </
		},
	})
end

return M
