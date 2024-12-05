local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local d = ls.dynamic_node
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

local function read_scopes_file()
	local file_path = vim.fn.getcwd() .. "/scopes.txt"
	local scopes = {}

	-- Try to open the file in read mode
	local file = io.open(file_path, "r")
	if file then
		-- Read each line and insert into scopes table
		for line in file:lines() do
			table.insert(scopes, t("(" .. line .. ")"))
		end
		file:close()
	else
		print("Failed to open file:", file_path)
	end

	return scopes
end

local function scopes_node()
	local options = read_scopes_file() or {}
	local default_options = { t(""), fmt("({})", { i(1) }) }

	-- Merge tables into options
	for k, v in pairs(default_options) do
		options[k] = v
	end

	return sn(nil, c(1, options or {}))
end

ls.add_snippets("gitcommit", {
	s(
		"commit",
		fmt(
			[[
				{}{}{}: {}

				{}

				{}
			]],
			{
				c(1, { sn(nil, fmt("[{}] ", { i(1) })), t("") }),
				c(2, { t("feat"), t("fix"), t("docs"), t("style"), t("refactor"), t("test"), t("chore"), t("ci"), t("build"), t("perf"), t("revert") }),
				c(3, { sn(1, fmt("{}", { d(1, scopes_node) })) }),
				i(4),
				i(5),
				i(6),
			}
		)
	),
})
