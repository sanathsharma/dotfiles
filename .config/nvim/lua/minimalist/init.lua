-- Enable loader to speed up start time
if vim.loader then
	vim.loader.enable()
end

-- core/ has zero plugin coupling by design, so it must run before the
-- plugin manager bootstraps: lazy.nvim loads every `lazy = false` plugin
-- synchronously inside its own setup() call, and any <leader>-prefixed
-- keymap registered before vim.g.mapleader is set resolves against Vim's
-- default leader ("\") instead of the leader configured below.
require("core.options").setup()
require("core.keymaps").setup()
require("core.autocmds")
require("core.usercmds")
require("core.project").load_project_config()
require("core.remove-clipboard").setup()

require("minimalist.lazy")
vim.cmd([[colorscheme catppuccin]])

-- Not backed by any plugin, so it doesn't need a lazy.nvim spec entry of its
-- own -- just called directly once fidget (used for its notifications) is
-- registered.
require("plugins.git.commit").setup()

-- Enable all LSPs for which setup is defined
require("plugins.lsp.lspconfig").enable()

-- Install required treesitter parsers
require("plugins.treesitter.treesitter").install()
