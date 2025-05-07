-- Lazy load snippets
require("luasnip.loaders.from_vscode").lazy_load({
	exclude = { "gitcommit" },
})
-- Lazy load project local snippets
local util = require("utils.find-code-snippet-paths")
local files = util.find_code_snippets_paths(vim.fn.getcwd() .. "/.vscode/")
for _, file in ipairs(files or {}) do
	require("luasnip.loaders.from_vscode").load_standalone({
		path = file,
	})
end

-- Load custom snippets
require("snippets.rust")
require("snippets.all")
require("snippets.javascript")
require("snippets.gitcommit")
