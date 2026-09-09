-- minimalist's theme is a fixed default (catppuccin), not the live Omarchy
-- system theme -- that's what the omarchy profile is for (see
-- lua/omarchy/lazy.lua, which imports lua/plugins/theme.lua, a symlink to
-- Omarchy's current theme, instead of this file).
--
-- The hot-reload plumbing is kept anyway so both profiles behave the same
-- way if a LazyReload event ever fires: it's an accepted lazy.nvim-specific
-- exception (it reaches directly into lazy.core.* internals and relies on
-- the LazyVim/LazyVim plugin's `opts.colorscheme` convention, so it can't be
-- made manager-agnostic), which is why it lives here in the manager-glue
-- layer rather than under lua/plugins/theming/ alongside the catppuccin
-- module (named "theming", not "theme", so it can't collide with Omarchy's
-- reserved lua/plugins/theme.lua -- lazy.nvim's `import` walks a same-named
-- sibling directory in addition to a leaf spec file, so a lua/plugins/theme/
-- directory here would corrupt the omarchy profile's live-theme import).

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("plugins.theming.catppuccin").setup()
		end,
	},
}
