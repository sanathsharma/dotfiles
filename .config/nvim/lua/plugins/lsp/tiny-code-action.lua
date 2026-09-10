local M = {}

function M.setup()
	require("tiny-code-action").setup({
		-- table form (not a bare string) so `opts.winopts` gets deep-merged onto
		-- this picker's own hardcoded winopts defaults -- it does not read
		-- fzf-lua's global setup() config otherwise
		picker = {
			"fzf-lua",
			opts = {
				winopts = {
					fullscreen = true,
					preview = {
						layout = "horizontal",
					},
				},
			},
		},
		backend = "delta",
		-- This backend runs delta via a plain argv spawn (no shell, no live
		-- $COLUMNS), so there's no reliable way to match the real preview pane
		-- width. --wrap-max-lines=0 sidesteps the problem entirely: delta prints
		-- full-length lines with no forced wrapping, verified empirically.
		-- --no-gitconfig is required too: ~/dotlocal/.gitconfig sets
		-- delta.side-by-side=true globally, and delta's --side-by-side is a bare
		-- switch with no CLI way to force it back off once set -- passing
		-- --side-by-side=false is a parse error (confirmed: exit 2, "unexpected
		-- value 'false'"), which silently produced "No preview available".
		-- Trade-off: this also drops the catppuccin-mocha delta theme/navigate
		-- settings from gitconfig for this preview only.
		backend_opts = {
			delta = {
				args = { "--no-gitconfig", "--line-numbers", "--wrap-max-lines=0" },
			},
		},
	})

	vim.keymap.set("n", "<leader>a", function()
		require("tiny-code-action").code_action()
	end, { desc = "Perform code actions" })

	vim.keymap.set("v", "<leader>a", function()
		require("tiny-code-action").code_action()
	end, { desc = "Perform visual mode code actions", silent = true })
end

return M
