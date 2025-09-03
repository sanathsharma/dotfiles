vim.cmd([[:cnoreabbrev Themes FzfLua colorschemes]])
vim.cmd([[:cnoreabbrev Livegrep FzfLua live_grep]])
vim.cmd([[:cnoreabbrev Marks FzfLua marks]])

-- Toggle
vim.cmd([[:cnoreabbrev Tblame Gitsigns toggle_current_line_blame]])
vim.cmd([[:cnoreabbrev Tdbui DBUIToggle]])

-- Reset
vim.cmd([[:cnoreabbrev Rhunk Gitsigns reset_hunk]])
vim.cmd([[:cnoreabbrev Rbuffer Gitsigns reset_buffer]])

-- Stage
vim.cmd([[:cnoreabbrev Shunk Gitsigns stage_hunk]])
vim.cmd([[:cnoreabbrev Sbuffer Gitsigns stage_buffer]])
