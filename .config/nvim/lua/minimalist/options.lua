vim.g.mapleader = " "                    -- Set leader key to space
vim.g.maplocalleader = "\\"              -- Set local leader key to backslash
vim.opt.relativenumber = true            -- Show relative line numbers
vim.opt.number = true                    -- Show absolute line number for current line
vim.opt.colorcolumn = "100,120"           -- Show vertical lines at columns 100 and 120
vim.opt.cursorline = true                -- Highlight current line
vim.opt.cursorcolumn = true              -- Highlight current column
vim.opt.expandtab = false              -- Use tabs instead of spaces
vim.opt.shiftwidth = 2                  -- Size of an indent
vim.opt.tabstop = 2                     -- Number of spaces tabs count for
vim.opt.softtabstop = 2                 -- Number of spaces for a tab when editing
vim.opt.scrolloff = 3
vim.opt.signcolumn = "yes"
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Enable loader to speed up start time
if vim.loader then
	vim.loader.enable()
end
