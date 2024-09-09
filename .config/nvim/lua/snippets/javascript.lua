local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local c = ls.choice_node
local sn = ls.snippet_node

ls.add_snippets("typescript", {
	s(
		"cs-query",
		fmt(
			[[
		export type {}Payload = {} {{
			{}
		}};

		export type {}Response = {}

		export const use{} = <Select = {}Response>(
			feature: Feature,
			payload: {}Payload,
			options?: Partial<UseQueryOptions<{}Response, {}, Select>>,
		) => {{
			return useQuery({{
				queryKey: [feature, {}, payload],
				queryFn: async ({{ signal }}) => {{
					const {{{}}} = payload;
					{}
				}},
				...(options ?? {{}}),
			}});
		}};
	]],
			{
				rep(1), -- request type name
				i(2), -- request type extension
				i(3), -- request type structure
				rep(1), -- response type name
				c(4, {
					sn(1, fmt([[ ListResponseBase<{}>; ]], { i(1) })),
					sn(
						2,
						fmt(
							[[
						{} {{
							{}
						}};
					]],
							{ i(1), i(2) }
						)
					),
				}), -- response type structure
				i(1), -- hook name
				rep(1), -- default select type
				rep(1), -- hook's payload argument type
				rep(1), -- use query options response type
				c(5, { sn(1, { t("ApiError"), i(1) }), t("unknown"), t("") }), -- error type
				c(6, { sn(1, { t("Resource"), i(1) }), t("") }), -- queryKey
				i(7), -- de-structure payload
				i(8), -- queryFn body
			}
		)
	),

	s(
		"cs-query-no-payload",
		fmt(
			[[
		export type {}Response = {}

		export const use{} = <Select = {}Response>(
			feature: Feature,
			options?: Partial<UseQueryOptions<{}Response, {}, Select>>,
		) => {{
			return useQuery({{
				queryKey: [feature, {}],
				queryFn: async ({{ signal }}) => {{
					{}
				}},
				...(options ?? {{}}),
			}});
		}};
	]],
			{
				rep(1), -- response type name
				c(2, {
					sn(1, fmt([[ ListResponseBase<{}>; ]], { i(1) })),
					sn(
						2,
						fmt(
							[[
						{} {{
							{}
						}};
					]],
							{ i(1), i(2) }
						)
					),
				}), -- response type structure
				i(1), -- hook name
				rep(1), -- default select type
				rep(1), -- use query options response type
				c(3, { sn(1, { t("ApiError"), i(1) }), t("unknown"), t("") }), -- error type
				c(4, { sn(1, { t("Resource"), i(1) }), t("") }), -- queryKey
				i(5), -- queryFn body
			}
		)
	),

	s(
		"cs-infinite-query",
		fmt(
			[[
		export type {}Payload = {} {{
			{}
		}};

		export type {}Response = {};

		export const use{} = <Select = {}Response>(
			feature: Feature,
			payload: {}Payload,
			options?: Partial<UseInfiniteQueryOptions<{}Response, {}, Select, {}Response, QueryKey, {}>>,
		) => {{
			return useInfiniteQuery({{
				queryKey: [feature, {}, payload],
				queryFn: async ({{ signal, pageParam }}) => {{
					const {{{}}} = payload;
					{}
				}},
				initialPageParam: {},
				getNextPageParam: (lastPage, allPages) => {{
					{}
				}},
				...(options ?? {{}}),
			}});
		}};
	]],
			{
				rep(1), -- request type name
				i(2), -- request type extension
				i(3), -- request type structure
				rep(1), -- response type name
				c(4, {
					sn(1, fmt([[ ListResponseBase<{}>; ]], { i(1) })),
					sn(
						2,
						fmt(
							[[
						{} {{
							{}
						}};
					]],
							{ i(1), i(2) }
						)
					),
				}), -- response type structure
				i(1), -- hook name
				rep(1), -- default select type
				rep(1), -- hook's payload argument type
				rep(1), -- use query options response type
				c(5, { sn(1, { t("ApiError"), i(1) }), t("unknown"), t("") }), -- error type
				rep(1), -- data type
				c(6, {t("number"), t("")}), -- page param type
				c(7, { sn(1, { t("Resource"), i(1) }), t("") }), -- queryKey
				i(8), -- de-structure payload
				i(9), -- queryFn body
				i(10), -- pageParam initial value
				i(11), -- getNextPageParam body
			}
		)
	),

	s(
		"cs-query-imports",
		fmt(
			[[
			import {{ useQuery, type UseQueryOptions }} from "@tanstack/react-query";
			import {{
				type Feature,
				Resource,
				type ApiError,
				type ListResponseBase,
				type ListPayloadQueryParams,
			}} from "@/services/types.ts";
			{}
		]],
			{
				i(1),
			}
		)
	),

	s(
		"cs-separator",
		fmt(
			[[
			// --------------------------------------------------------------------------------------------------------------------
			{}
			]],
			{ i(1) }
		),
		t()
	),
})
