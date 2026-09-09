-- Which-key is purely optional decoration: every real keymap across the
-- config is set with vim.keymap.set + desc, which which-key auto-discovers.
-- The only thing this module owns is cosmetic group labels for leader
-- prefixes that have no keymap of their own.

local M = {}

function M.setup()
	require("which-key").setup({
		preset = "helix",
		spec = {
			{ "<leader>t", group = "toggle" },
			{ "<leader>,", group = "Dap" },
			{ "<leader>.", group = "test" },
			{ "<leader>l", group = "lazy" },
			{ "<leader>p", group = "99" },
		},
	})
end

return M
