local enable_lsps = {
	"lua_ls",
	-- "rust_analyzer", -- Managed by rustaceanvim
	"biome",
	"ts_ls",
	"tailwindcss",
	"taplo", -- toml
	"emmet_language_server",
	"css_variables",
	"cssmodules_ls",
	"cssls",
	"html",
	"marksman", -- markdown
}

local treesitter_parsers = {
	"rust",
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"toml",
	"yaml",
	"json",
	"sh",
	"lua",
	"markdown",
}

return {
	enable_lsps = enable_lsps,
	treesitter_parsers = treesitter_parsers,
}
