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
		if require("minimalist.utils").is_dadbod_temp_dir() then
			return
		end

		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype
		require("lint").try_lint()

		-- You can call `try_lint` with a linter name or a list of names to always
		-- run specific linters, independent of the `linters_by_ft` configuration
		-- require("lint").try_lint("cspell")
	end,
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

vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "markdown" },
	callback = function()
		if
			string.sub(vim.fn.expand("%:p"), 1, string.len(vim.fn.expand("~") .. "/vaults/"))
			== vim.fn.expand("~") .. "/vaults/"
		then
			vim.opt.conceallevel = 2
		end
	end,
})

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, "\"")
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

-- no auto continue comments on new line
-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
-- 	callback = function()
-- 		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
-- 	end,
-- })

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = "active_cursorline",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		-- Only run if the cursor is not in insert mode
		if vim.fn.mode() ~= "i" then
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break -- Found a supporting client, no need to check others
				end
			end

			-- 3. Proceed only if an LSP is active AND supports the feature
			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMovedI", {
	group = "LspReferenceHighlight",
	desc = "Clear highlights when entering insert mode",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})
