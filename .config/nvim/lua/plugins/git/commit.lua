-- Not backed by any plugin: wires up the "generate a commit message" keymap
-- for the gitcommit filetype using whichever external CLI this machine has.

local M = {}

local function setup_keymaps()
	local hostname = vim.uv.os_gethostname()
	if hostname == "pop-os" then
		vim.keymap.set("n", "<c-c><c-g>", function()
			local fidget = require("fidget")
			fidget.notify("Generating commit message...", vim.log.levels.INFO, { title = "gen-commit" })

			vim.system({ "gen-commit", "--print" }, { text = true }, function(obj)
				if obj.code ~= 0 then
					fidget.notify("Failed to generate commit message!", vim.log.levels.ERROR, { title = "gen-commit" })
					return
				end

				local result = obj.stdout:gsub("^%s+", ""):gsub("%s+$", "")
				vim.schedule(function()
					vim.api.nvim_buf_set_lines(0, 0, 0, false, { result })
					require("fidget").notify("Commit message generated!", vim.log.levels.INFO, { title = "gen-commit" })
				end)
			end)
		end, { desc = "Commit with gen-commit cli" })
		return
	end

	vim.keymap.set(
		"n",
		"<c-c><c-g>",
		"<cmd>read !./scripts/commit-claude.lua --print<cr>",
		{ desc = "Commit with claude code" }
	)
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("gitcommit-keymaps-load", { clear = true }),
		pattern = { "gitcommit" },
		callback = setup_keymaps,
	})
end

return M
