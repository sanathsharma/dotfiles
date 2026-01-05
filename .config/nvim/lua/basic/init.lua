-- Enable loader to speed up start time
if vim.loader then
	vim.loader.enable()
end

require("basic.plugins")
require("minimalist.options").setup()
require("minimalist.autocmds")
require("minimalist.usercmds")
require("minimalist.aliases")

-- Enable all LSPs for which setup is defined
require("minimalist.lsp").enable()

-- Set default theme
vim.cmd("colorscheme rose-pine-main")
