-- Enable loader to speed up start time
if vim.loader then
	vim.loader.enable()
end

require("minimalist.lazy")
require("minimalist.options")
require("minimalist.autocmds")
require("minimalist.usercmds")
require("minimalist.project").load_project_config()

-- Enable all LSPs for which setup is defined
require("minimalist.lsp").enable()

-- Set default theme
vim.cmd("colorscheme tokyonight-night")
