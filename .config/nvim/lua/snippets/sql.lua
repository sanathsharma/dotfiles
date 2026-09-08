local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
-- local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
-- local c = ls.choice_node

ls.add_snippets("sql", {
	s(
		"pg-createuser-and-db",
		fmt(
			[[
			CREATE USER {} WITH PASSWORD '{}';
			CREATE DATABASE {} OWNER {};
		]],
			{
				i(1, "username"),
				i(2, "password"),
				i(3, "database"),
				rep(1),
			}
		)
	),
})
