local M = {}

local function setup_keymaps()
	vim.keymap.set({ "n", "x", "o" }, "<leader>to", function()
		require("rustowl").toggle()
	end, { desc = "Toggle rustowl" })
end

function M.setup()
	setup_keymaps()

	require("rustowl").setup({
		auto_attach = true,
		auto_enable = false,
		highlight_style = "underline",
		idle_time = 500,
		colors = {
			lifetime = "#50fa7b", -- Dracula green
			imm_borrow = "#8be9fd", -- Dracula cyan
			mut_borrow = "#ff79c6", -- Dracula pink
			move = "#f1fa8c", -- Dracula yellow
			call = "#ffb86c", -- Dracula orange
			outlive = "#ff5555", -- Dracula red
		},
	})
end

return M
