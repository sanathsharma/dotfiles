-- User commands with zero plugin coupling. Anything that depends on a
-- plugin lives in that plugin's own module under lua/plugins/<category>/.

-- Register extended functionality commands
local extended = require("core.extended")
extended.register_case_commands()
extended.register_lsp_case_commands()

vim.api.nvim_create_user_command("CopyPath", function()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		vim.notify("No file associated with current buffer", vim.log.levels.WARN)
		return
	end
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy full path of current buffer to clipboard" })

vim.api.nvim_create_user_command("CopyRelPath", function()
	local full_path = vim.api.nvim_buf_get_name(0)
	if full_path == "" then
		vim.notify("No file associated with current buffer", vim.log.levels.WARN)
		return
	end
	local rel_path = vim.fn.fnamemodify(full_path, ":.")
	vim.fn.setreg("+", rel_path)
	vim.notify("Copied: " .. rel_path, vim.log.levels.INFO)
end, { desc = "Copy relative path of current buffer to clipboard" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function(args)
		vim.api.nvim_buf_create_user_command(args.buf, "JqMinify", function()
			vim.cmd("%!jq -c .")
		end, { desc = "Minify JSON using jq" })
	end,
})
