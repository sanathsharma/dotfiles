local M = {}

local function setup_keymaps()
	vim.keymap.set("n", "[h", "<cmd>Gitsigns nav_hunk prev<cr>", { desc = "Previous hunk" })
	vim.keymap.set("n", "]h", "<cmd>Gitsigns nav_hunk next<cr>", { desc = "Next hunk" })
	vim.keymap.set("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle current line blame" })
end

function M.setup()
	require("gitsigns").setup({
		sign_priority = 11,
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "󰍵" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "│" },
		},
		signs_staged = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "󰍵" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "│" },
		},
	})

	setup_keymaps()
end

return M
