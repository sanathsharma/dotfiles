local M = {}

function M.setup()
	require("tabout").setup({
		completion = false, -- nvim-cmp-only integration; irrelevant with blink.cmp
	})
end

return M
