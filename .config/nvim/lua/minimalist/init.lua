require("minimalist.lazy")
require("minimalist.options")
require("minimalist.autocmds")
require("minimalist.usercmds")

local enable_lsps = {
  "lua_ls",
  "rust_analyzer",
	"biome",
	"ts_ls",
	"tailwindcss",
	"taplo", -- toml
	"emmet_language_server",
	"css_variables",
	"cssmodules_ls",
	"cssls",
	"html",
}

for _, lsp in ipairs(enable_lsps) do
	vim.lsp.enable(lsp)
end
