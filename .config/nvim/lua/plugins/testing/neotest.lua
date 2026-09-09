local M = {}

local function setup_keymaps()
	vim.keymap.set("n", "<leader>.t", function()
		require("neotest").run.run(vim.fn.expand("%"))
	end, { desc = "Run File (Neotest)" })

	vim.keymap.set("n", "<leader>.T", function()
		require("neotest").run.run(vim.uv.cwd())
	end, { desc = "Run All Test Files (Neotest)" })

	vim.keymap.set("n", "<leader>.r", function()
		require("neotest").run.run()
	end, { desc = "Run Nearest (Neotest)" })

	vim.keymap.set("n", "<leader>.d", function()
		require("neotest").run.run({ strategy = "dap" })
	end, { desc = "Run Nearest with DAP (Neotest)" })

	vim.keymap.set("n", "<leader>.l", function()
		require("neotest").run.run_last()
	end, { desc = "Run Last (Neotest)" })

	vim.keymap.set("n", "<leader>.s", function()
		require("neotest").summary.toggle()
	end, { desc = "Toggle Summary (Neotest)" })

	vim.keymap.set("n", "<leader>.o", function()
		require("neotest").output.open({ enter = true, auto_close = true })
	end, { desc = "Show Output (Neotest)" })

	vim.keymap.set("n", "<leader>.O", function()
		require("neotest").output_panel.toggle()
	end, { desc = "Toggle Output Panel (Neotest)" })

	vim.keymap.set("n", "<leader>.S", function()
		require("neotest").run.stop()
	end, { desc = "Stop (Neotest)" })

	vim.keymap.set("n", "<leader>.w", function()
		require("neotest").watch.toggle(vim.fn.expand("%"))
	end, { desc = "Toggle Watch (Neotest)" })
end

function M.setup()
	require("neotest").setup({
		adapters = {
			require("rustaceanvim.neotest"),
		},
	})

	setup_keymaps()
end

return M
