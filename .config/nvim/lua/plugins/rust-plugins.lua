return {
	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		ft = { "rust" },
		lazy = false,
		dependencies = "neovim/nvim-lspconfig",
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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
			}
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
