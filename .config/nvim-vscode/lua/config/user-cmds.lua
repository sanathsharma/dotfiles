-- copy current buffer paths
vim.api.nvim_create_user_command("CopyCurrentBufferFullPath", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":p")
	vim.fn.setreg("+", path) -- put path to + register (clipboard)
	vim.notify("Copied \"" .. path .. "\" to the clipboard!")
end, { nargs = 0 })
vim.api.nvim_create_user_command("CopyCurrentBufferRelPath", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), "")
	vim.fn.setreg("+", path) -- put path to + register (clipboard)
	vim.notify("Copied \"" .. path .. "\" to the clipboard!")
end, { nargs = 0 })

vim.api.nvim_create_user_command("KillPort", function(parms)
	vim.cmd("!npx kill-port" .. parms.args .. ")")
end, { nargs = 1 })

-- make the current sh script into an executable
vim.api.nvim_create_user_command("MakeExecutable", function()
	vim.cmd("!chmod +x %")
end, { nargs = 0 })

