-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Filetype support for .env.development or .env.local
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = ".env*",
	command = "set filetype=sh",
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "json", "jsonc", "code-snippets" },
	callback = function()
		vim.wo.spell = false
		vim.wo.conceallevel = 0

		-- Formatting json output for rest.nvim,
		-- see https://github.com/rest-nvim/rest.nvim/issues/417#issuecomment-2322786365
		vim.api.nvim_set_option_value("formatprg", "jq", { scope = "local" })
	end,
})

-- Fix conceallevel for json files
-- vim.api.nvim_create_autocmd("Filetype", {
-- 	pattern = { "rust" },
-- 	callback = function()
-- 		-- color 100th column to identify formatter overflow
-- 		vim.opt.colorcolumn = "100"
-- 	end,
-- })
