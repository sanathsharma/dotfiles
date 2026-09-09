local M = {}

function M.init()
	-- mark netrw as loaded so it's not loaded at all.
	--
	-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
	vim.g.loaded_netrwPlugin = 1
end

function M.setup()
	---@type YaziConfig | {}
	require("yazi").setup({
		open_for_directories = false,
		keymaps = {
			show_help = "<f1>",
		},
		yazi_floating_window_zindex = nil,
	})

	vim.keymap.set("n", "<leader>e", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
end

return M
