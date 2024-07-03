local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
-- local extras = require("luasnip.extras")
-- local rep = extras.rep
local c = ls.choice_node

ls.add_snippets("rust", {
	s(
		"p",
		fmt([[ println!("->> {{:<12}} -- {}", "{}"); ]], {
			i(2),
			c(1, { t("HANDLER"), t("MIDDLEWARE"), t("EXTRACTOR"), t("INTO_RES"), t("RES_MAPPER"), t("") }),
		})
	),
	s(
		"info",
		fmt([[ info!("{{:<12}} -- {}", "{}"); ]], {
			i(2),
			c(1, { t("HANDLER"), t("MIDDLEWARE"), t("EXTRACTOR"), t("INTO_RES"), t("RES_MAPPER"), t("") }),
		})
	),
	s(
		"debug",
		fmt([[ debug!("{{:<12}} -- {}", "{}"); ]], {
			i(2),
			c(1, { t("HANDLER"), t("MIDDLEWARE"), t("EXTRACTOR"), t("INTO_RES"), t("RES_MAPPER"), t("") }),
		})
	),
})
