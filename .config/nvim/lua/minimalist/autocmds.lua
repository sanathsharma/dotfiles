-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Run linters
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype
		require("lint").try_lint()

		-- You can call `try_lint` with a linter name or a list of names to always
		-- run specific linters, independent of the `linters_by_ft` configuration
		-- require("lint").try_lint("cspell")
	end,
})

-- Filetype support for .env.development or .env.local
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = ".env*",
	command = "set filetype=sh",
})

-- Set default options for rust
vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "rust" },
	callback = function()
		local default_max_width = 80
		local default_tab_spaces = 4

		local max_width = default_max_width
		local tab_spaces = default_tab_spaces

		-- Try to read rustfmt.toml configuration
		local rustfmt_path = vim.fn.findfile("rustfmt.toml", ".;")
		if rustfmt_path ~= "" then
			local file = io.open(rustfmt_path, "r")
			if file then
				local content = file:read("*all")
				file:close()

				-- Parse max_width
				local width_match = content:match("max_width%s*=%s*(%d+)")
				if width_match then
					max_width = tonumber(width_match) or default_max_width
				end

				-- Parse tab_spaces
				local tab_match = content:match("tab_spaces%s*=%s*(%d+)")
				if tab_match then
					tab_spaces = tonumber(tab_match) or default_tab_spaces
				end
			end
		end

		vim.opt.colorcolumn = tostring(max_width)
		vim.opt.expandtab = false -- Use tabs instead of spaces
		vim.opt.shiftwidth = tab_spaces -- Size of an indent
		vim.opt.shiftround = true -- Round indent to multiple of shiftwidth
		vim.opt.tabstop = tab_spaces -- Number of spaces tabs count for
		vim.opt.softtabstop = tab_spaces -- Number of spaces for a tab when editing
	end,
})
