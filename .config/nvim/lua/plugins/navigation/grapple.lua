local M = {}

local function setup_keymaps()
	vim.keymap.set("n", "<leader>h", "<cmd>Grapple toggle_tags<cr>", { desc = "Toggle tags menu" })
	vim.keymap.set("n", "<leader>ha", "<cmd>Grapple toggle<cr>", { desc = "Tag a file" })
	vim.keymap.set("n", "<leader>hm", "<cmd>Grapple toggle_tags<cr>", { desc = "Toggle tags menu" })

	vim.keymap.set("n", "<leader>1", "<cmd>Grapple select index=1<cr>", { desc = "Select first tag" })
	vim.keymap.set("n", "<leader>2", "<cmd>Grapple select index=2<cr>", { desc = "Select second tag" })
	vim.keymap.set("n", "<leader>3", "<cmd>Grapple select index=3<cr>", { desc = "Select third tag" })
	vim.keymap.set("n", "<leader>4", "<cmd>Grapple select index=4<cr>", { desc = "Select fourth tag" })
	vim.keymap.set("n", "<leader>5", "<cmd>Grapple select index=5<cr>", { desc = "Select fifth tag" })
end

function M.setup()
	require("grapple").setup({
		scope = "git_branch",
		icons = false,
		status = false,
	})

	setup_keymaps()
end

return M
