local enable_lsps = {
	"biome",
	"cssls",
	"cssmodules_ls",
	"css_variables",
	"emmet_language_server",
	"html",
	"lua_ls",
	"marksman", -- markdown
	-- "rust_analyzer", -- Managed by rustaceanvim
	"stylelint_lsp",
	"svelte",
	"tailwindcss",
	"taplo", -- toml
	"ts_ls",
	"yamlls",
	"jsonls",
}

local treesitter_parsers = {
	"javascript",
	"javascriptreact",
	"json",
	"lua",
	"markdown",
	"rust",
	"sh",
	"svelte",
	"toml",
	"typescript",
	"typescriptreact",
	"yaml",
}

local stylelint_files = {
	".stylelintrc",
	".stylelintrc.mjs",
	".stylelintrc.cjs",
	".stylelintrc.js",
	".stylelintrc.json",
	".stylelintrc.yaml",
	".stylelintrc.yml",
	"stylelint.config.mjs",
	"stylelint.config.cjs",
	"stylelint.config.js",
}

return {
	enable_lsps = enable_lsps,
	treesitter_parsers = treesitter_parsers,
	stylelint_files = stylelint_files,
}
