local M = {}

local function setup_keymaps()
	vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<cr>", { desc = "Open file picker" })
	vim.keymap.set("n", "<leader>F", function()
		require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
	end, { desc = "Open file picker in current buffer directory" })
	vim.keymap.set("n", "<leader><leader>", "<cmd>Fmt<cr>", { desc = "Format file" })
	vim.keymap.set("n", "<leader>'", "<cmd>FzfLua resume<cr>", { desc = "Open last picker" })
	vim.keymap.set("n", "<leader>b", "<cmd>FzfLua buffers<cr>", { desc = "Open buffer picker" })
	vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Global search in workspace folder" })
	vim.keymap.set("n", "<leader>w", "<cmd>FzfLua grep_cword<cr>", { desc = "Search word under cursor" })
	vim.keymap.set("n", "<leader>j", "<cmd>FzfLua jumps<cr>", { desc = "Open jumplist picker" })
	vim.keymap.set("n", "<leader>s", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Open symbol picker" })
	vim.keymap.set("n", "<leader>S", "<cmd>FzfLua lsp_workspace_symbols<cr>", { desc = "Open workspace symbol picker" })
	vim.keymap.set("n", "<leader>d", "<cmd>FzfLua lsp_document_diagnostics<cr>", { desc = "Open diagnostic picker" })
	vim.keymap.set(
		"n",
		"<leader>D",
		"<cmd>FzfLua lsp_workspace_diagnostics<cr>",
		{ desc = "Open workspace diagnostic picker" }
	)
	vim.keymap.set("n", "<leader>g", "<cmd>FzfLua git_status<cr>", { desc = "Open changed file picker" })
	vim.keymap.set("n", "<leader>o", "<cmd>FzfLua lsp_incoming_calls<cr>", { desc = "Open incoming calls picker" })
	vim.keymap.set("n", "<leader>O", "<cmd>FzfLua lsp_outgoing_calls<cr>", { desc = "Open outgoing calls picker" })
	vim.keymap.set("n", "<leader>a", "<cmd>FzfLua lsp_code_actions<cr>", { desc = "Perform code actions" })
	vim.keymap.set("n", "<leader>m", "<cmd>FzfLua keymaps<cr>", { desc = "Search and select keymaps" })

	vim.keymap.set(
		"v",
		"<leader>a",
		"<cmd>FzfLua lsp_code_actions<cr>",
		{ desc = "Perform visual mode code actions", silent = true }
	)
end

function M.init()
	require("fzf-lua").register_ui_select()
end

function M.setup()
	require("fzf-lua").setup({
		winopts = {
			fullscreen = true,
		},
		grep = {
			hidden = true,
		},
		files = {
			previewer = "bat",
			hidden = true,
		},
		colorschemes = {
			winopts = {
				fullscreen = false,
			},
		},
		marks = {
			winopts = {
				fullscreen = false,
			},
		},
		fzf_colors = true,
		lsp = {
			code_actions = {
				-- Use the native fzf previewer for better integration with shell pagers
				previewer = "codeaction_native",
				-- Configure delta for syntax-highlighted diff previews
				preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
			},
		},
	})

	setup_keymaps()
end

return M
