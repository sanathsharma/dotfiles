local M = {}

local function setup_keymaps()
	local ls = require("luasnip")

	vim.keymap.set({ "i", "s" }, "<C-Up>", function()
		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end, { silent = true, desc = "Expand snippet or jump" })

	vim.keymap.set({ "i", "s" }, "<C-Right>", function()
		if ls.choice_active() then
			ls.change_choice(1)
		end
	end, { silent = true, desc = "Change choice" })

	vim.keymap.set({ "i", "s" }, "<C-Down>", function()
		if ls.jumpable(-1) then
			ls.jump(-1)
		end
	end, { silent = true, desc = "Jump backward" })
end

function M.setup()
	local luasnip = require("luasnip")
	local types = require("luasnip.util.types")

	luasnip.config.setup({
		history = true,
		delete_check_events = "TextChanged",
		keep_roots = true,
		link_roots = true,
		link_children = true,
		exit_roots = false,
		update_events = "TextChanged,TextChangedI",
		-- enable_autosnippets = true,
		ext_ops = {
			[types.choiceNode] = {
				active = {
					virt_text = { { "⇐", "Error" } },
				},
			},
		},
	})

	-- Load snippets from lua/plugins/completion/snippets
	require("plugins.completion.snippets")
	setup_keymaps()

	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
end

return M
