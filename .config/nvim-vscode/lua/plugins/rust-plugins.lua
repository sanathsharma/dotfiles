return {
	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		ft = { "rust" },
		cond = function ()
			return vim.g.vscode == nil
		end,
		dependencies = "neovim/nvim-lspconfig",
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			vim.g.rustaceanvim = function()
				local mason_registry = require("mason-registry")

				local codelldb = mason_registry.get_package("codelldb")
				local extension_path = codelldb:get_install_path() .. "/extension/"
				local codelldb_path = extension_path .. "adapter/codelldb"
				local liblldb_path = extension_path .. "lldb/lib/liblldb"

				local this_os = vim.uv.os_uname().sysname;

				-- The path is different on Windows
				if this_os:find "Windows" then
					codelldb_path = extension_path .. "adapter\\codelldb.exe"
					liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
				else
					-- The liblldb extension is .so for Linux and .dylib for MacOS
					liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
				end

				local cfg = require("rustaceanvim.config")
				return {
					dap = {
						adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
					},
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
		end,
	},
	{
		"saecki/crates.nvim",
		ft = { "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			require("cmp").setup.buffer({
				sources = { { name = "crates" } },
			})
			crates.show()
			-- require("core.utils").load_mappings("crates")

			-- keymapings
			vim.keymap.set("n", "<leader>ur", function()
				require("crates").upgrade_all_crates()
			end, { desc = "Upgrade [r]ust crates" })
		end,
	},
	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},
}
