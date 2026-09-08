local M = {}

local function setup_keymaps()
	local _99 = require("99")

	vim.keymap.set("n", "<leader>ps", function()
		_99.search({})
	end, { desc = "99: Search" })

	vim.keymap.set("n", "<leader>px", function()
		_99.stop_all_requests()
	end, { desc = "99: Cancel all requests" })

	vim.keymap.set("n", "<leader>pm", function()
		require("99.extensions.fzf_lua").select_model()
	end, { desc = "99: Select model" })

	vim.keymap.set("n", "<leader>pp", function()
		require("99.extensions.fzf_lua").select_provider()
	end, { desc = "99: Select provider" })

	vim.keymap.set("v", "<leader>pv", function()
		_99.visual({})
	end, { desc = "99: Replace selection with AI output" })
end

function M.setup()
	local _99 = require("99")
	local cwd = vim.uv.cwd()
	local basename = vim.fs.basename(cwd)
	---@type _99.Providers.BaseProvider
	local provider = _99.Providers.ClaudeCodeProvider
	local model = "claude-sonnet-5"

	_99.setup({
		provider = provider,
		model = model,
		logger = {
			level = _99.DEBUG,
			path = "/tmp/" .. basename .. ".99.debug",
			print_on_error = true,
		},
		tmp_dir = "./tmp",
	})

	setup_keymaps()
end

return M
