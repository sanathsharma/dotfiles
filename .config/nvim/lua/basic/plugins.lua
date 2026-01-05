-- Themes
vim.pack.add({
	{ src = "https://github.com/rose-pine/neovim.git" },
})

-- Navigation
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
})

require("mini.pick").setup()
require("oil").setup({
	default_file_explorer = true,
	keymaps = {
		["?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<C-v>"] = "actions.select_vsplit",
		["<C-h>"] = "actions.select_split",
		["<C-t>"] = "actions.select_tab",
		["<C-p>"] = "actions.preview",
		["q"] = { "actions.close", mode = "n" },
		["r"] = "actions.refresh",
		["-"] = "actions.parent",
		["_"] = "actions.open_cwd",
		["`"] = "actions.cd",
		["~"] = "actions.tcd",
		["gs"] = "actions.change_sort",
		["gx"] = "actions.open_external",
		["."] = "actions.toggle_hidden",
		["g\\"] = "actions.toggle_trash",
	},
	view_options = {
		show_hidden = true,
	},
	columns = {},
})
require("which-key").setup({
	preset = "helix",
})
require("minimalist.keymaps").setup()
require("minimalist.keymaps").setup_lazy_module_keymaps()
