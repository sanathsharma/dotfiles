local M = {}

local function jump()
	require("flash").jump()
end

local function treesitter_jump()
	require("flash").treesitter({
		actions = {
			["<Up>"] = "next",
			["<Down>"] = "prev",
		},
	})
end

function M.setup()
	vim.keymap.set("n", "gw", jump, { desc = "Flash" })
	vim.keymap.set("n", "gW", treesitter_jump, { desc = "Flash Treesitter" })

	vim.keymap.set({ "x", "o" }, "s", jump, { desc = "Flash" })
	vim.keymap.set({ "x", "o" }, "S", treesitter_jump, { desc = "Flash Treesitter" })

	vim.keymap.set("o", "r", function()
		require("flash").remote()
	end, { desc = "Remote Flash" })

	vim.keymap.set({ "o", "x" }, "R", function()
		require("flash").treesitter_search()
	end, { desc = "Treesitter Search" })

	vim.keymap.set("c", "<c-s>", function()
		require("flash").toggle()
	end, { desc = "Toggle Flash Search" })
end

return M
