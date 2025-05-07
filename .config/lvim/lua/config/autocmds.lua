-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
vim.api.nvim_create_user_command("Fmt", function()
	vim.lsp.buf.format()
end, { nargs = 0 })

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
vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "rust" },
	callback = function()
		-- color 100th column to identify formatter overflow
		vim.opt.colorcolumn = "100"
	end,
})

-- copy current buffer paths
vim.api.nvim_create_user_command("CopyCurrentBufferFullPath", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":p")
	vim.fn.setreg("+", path) -- put path to + register (clipboard)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, { nargs = 0 })
vim.api.nvim_create_user_command("CopyCurrentBufferRelPath", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), "")
	vim.fn.setreg("+", path) -- put path to + register (clipboard)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, { nargs = 0 })

vim.api.nvim_create_user_command("KillPort", function(parms)
	vim.cmd("!sudo kill -S -9 $(sudo lsof -t -i:" .. parms.args .. ")")
end, { nargs = 1 })

-- make the current sh script into an executable
vim.api.nvim_create_user_command("MakeExecutable", function()
	vim.cmd("!chmod +x %")
end, { nargs = 0 })

-- source snippets
vim.api.nvim_create_user_command("SourceSnippets", function()
	vim.cmd("luafile ~/.config/nvim/lua/snippets/init.lua")
end, { nargs = 0 })
