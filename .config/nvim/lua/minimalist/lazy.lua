-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ---------------------------------------------------------------------------------------------------------------------
-- Plugins setup: every category under lua/minimalist/plugins/ is this
-- profile's own curated plugin selection, wired to the manager-agnostic
-- modules under lua/plugins/.
-- ---------------------------------------------------------------------------------------------------------------------

-- Suppresses LazyVim's own require-order health check, which the bare
-- LazyVim/LazyVim dependency below would otherwise trip: minimalist never
-- calls require("lazyvim").setup(), so no LazyVim distro config/keymaps/
-- autocmds ever run -- LazyVim/LazyVim is here purely so lua/minimalist/theme.lua's
-- hot-reload logic has its opts.colorscheme convention to scan for.

local lazy_loader = require("lazy_loader")
local spec = lazy_loader.load_dir("minimalist.plugins")
-- fixed default theme (catppuccin) + the omarchy hot-reload plumbing;
-- declares LazyVim/LazyVim itself, so it isn't repeated here
vim.list_extend(spec, require("minimalist.theme"))

require("lazy").setup(spec)

-- lazy.nvim-specific: force-load a plugin that's otherwise deferred behind
-- an event/cmd/ft trigger.
vim.keymap.set("n", "<leader>ld", "<cmd>Lazy load nvim-dap-view<cr>", { desc = "Lazy load dap setup" })
vim.keymap.set("n", "<leader>lt", "<cmd>Lazy load neotest<cr>", { desc = "Lazy load neotest" })
vim.keymap.set("n", "<leader>lD", "<cmd>Lazy load diffview.nvim<cr>", { desc = "Lazy load diffview" })
