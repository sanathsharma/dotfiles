local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local d = ls.dynamic_node
local sn = ls.snippet_node
local t = ls.text_node

local function filename_base(_args)
	return sn(nil, t(vim.fn.expand("%:t:r")))
end

ls.add_snippets("all", {
	s("filename_base", fmt("{}", { d(1, filename_base) })),
})
