local M = {}

function M.setup_rustaceanvim()
	local capabilities = require("blink.cmp").get_lsp_capabilities()
	vim.g.rustaceanvim = {
		server = {
			cmd = { "rustup", "run", "stable", "rust-analyzer" },
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					cargo = { allFeatures = true },
				},
			},
		},
		tools = {
			hover_actions = {
				auto_focus = true,
			},
		},
	}
end

local function setup_rust_format_opts()
	local default_max_width = 80
	local default_tab_spaces = 4

	local max_width = default_max_width
	local tab_spaces = default_tab_spaces

	-- Try to read rustfmt.toml configuration
	local rustfmt_path = vim.fn.findfile("rustfmt.toml", ".;")
	if type(rustfmt_path) == "string" and rustfmt_path ~= "" then
		local file = io.open(rustfmt_path, "r")
		if file then
			local content = file:read("*all")
			file:close()

			-- Parse max_width
			local width_match = content:match("max_width%s*=%s*(%d+)")
			if width_match then
				max_width = tonumber(width_match) or default_max_width
			end

			-- Parse tab_spaces
			local tab_match = content:match("tab_spaces%s*=%s*(%d+)")
			if tab_match then
				tab_spaces = tonumber(tab_match) or default_tab_spaces
			end
		end
	end

	vim.opt.colorcolumn = tostring(max_width)
	vim.opt.expandtab = true -- Use tabs instead of spaces
	vim.opt.shiftwidth = tab_spaces -- Size of an indent
	vim.opt.shiftround = true -- Round indent to multiple of shiftwidth
	vim.opt.tabstop = tab_spaces -- Number of spaces tabs count for
	vim.opt.softtabstop = tab_spaces -- Number of spaces for a tab when editing
end

local function setup_keymaps()
	-- vim.keymap.set("n", "<leader>a", function()
	-- 	vim.cmd.RustLsp("codeAction")
	-- end, { silent = true, buffer = 0, noremap = true, desc = "Rust code action" })

	vim.keymap.set("n", "K", function()
		vim.cmd.RustLsp({ "hover", "actions" })
	end, { silent = true, buffer = 0, noremap = true, desc = "Rust hover actions" })
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("rustaceanvim-ft", { clear = true }),
		pattern = { "rust" },
		callback = function()
			setup_rust_format_opts()
			setup_keymaps()
		end,
	})
end

return M
