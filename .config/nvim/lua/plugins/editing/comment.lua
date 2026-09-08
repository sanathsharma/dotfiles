local M = {}

function M.setup()
	local api = require("Comment.api")

	vim.keymap.set("n", "<leader>c", function()
		api.toggle.linewise.current()
	end, { desc = "Comment/uncomment selections" })

	vim.keymap.set("n", "<leader>C", function()
		api.toggle.blockwise.current()
	end, { desc = "Block comment/uncomment selections" })

	vim.keymap.set("x", "<leader>c", function()
		api.toggle.linewise(vim.fn.visualmode())
	end, { desc = "Comment/uncomment selections" })

	vim.keymap.set("x", "<leader>C", function()
		api.toggle.blockwise(vim.fn.visualmode())
	end, { desc = "Block comment/uncomment selections" })
end

return M
