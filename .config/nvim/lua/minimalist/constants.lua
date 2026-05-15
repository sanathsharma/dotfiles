local enable_lsps = {
	"biome",
	"clangd",
	"css_variables",
	"cssls",
	"cssmodules_ls",
	"emmet_language_server",
	"html",
	"jsonls",
	"lua_ls",
	"marksman", -- markdown
	"stylelint_lsp",
	"svelte",
	"tailwindcss",
	"taplo", -- toml
	"ts_ls",
	"yamlls",
	-- "rust_analyzer", -- Managed by rustaceanvim
}

local treesitter_parsers = {
	"bash",
	"c",
	"fish",
	"javascript",
	"json",
	"jsx",
	"lua",
	"markdown",
	"rust",
	"svelte",
	"toml",
	"tsx",
	"typescript",
	"yaml",
	"zsh",
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
