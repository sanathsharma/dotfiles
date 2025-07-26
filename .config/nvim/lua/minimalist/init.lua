require("minimalist.lazy")
require("minimalist.options")
require("minimalist.autocmds")
require("minimalist.usercmds")

-- Enable all LSPs for which setup is defined
require("minimalist.lsp").enable()
