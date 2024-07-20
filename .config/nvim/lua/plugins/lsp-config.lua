return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local util = require("lspconfig/util")

			-- tsserver setup
			local function organize_imports()
				local params = {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
				}
				vim.lsp.buf.execute_command(params)
			end

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = { vim.env.VIMRUNTIME },
							},
							completion = {
								enable = true,
								callSnippet = "Replace",
							},
							telemetry = { enable = false },
							hint = {
								enable = true,
								arrayIndex = "Disable",
							},
						},
					},
				},
				-- biome = {},
				tsserver = {
					init_options = {
						preferences = {
							disableSuggestions = false,
							-- region: inlay hints preferences
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = false,
							includeInlayEnumMemberValueHints = true,
							importModuleSpecifierPreference = "non-relative",
							-- endregion: inlay hints preferences
						},
					},
					commands = {
						OrganizeImportsTS = {
							organize_imports,
							description = "Organize Imports",
						},
					},
					on_attach = function()
						-- auto run OrganizeImports for js/ts files when file is saved
						-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
						-- 	command = "OrganizeImportsTS",
						-- 	pattern = { "*.js", "*.jsx", "*.cjs", "*.ts", "*.tsx" },
						-- })

						vim.keymap.set("n", "<leader>ai", "<cmd>OrganizeImportsTS<CR>", { desc = "Organize [I]mports" })
					end,
				},
				gopls = {
					cmd = { "gopls" },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					root_dir = util.root_pattern("go.work", "go.mod", ".git"),
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							analyses = {
								unusedparams = true,
							},
						},
					},
				},
				-- INFO: configured by mrcjkb/rustaceanvim, so below code block is not required
				-- rust_analyzer = {
				-- 	cmd = { "rustup", "run", "stable", "rust-analyzer" },
				-- 	settings = {
				-- 		["rust-analyzer"] = {
				-- 			cargo = { allFeatures = true },
				-- 		},
				-- 	},
				-- },
				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},
				yamlls = {
					-- See https://github.com/redhat-developer/yaml-language-server/issues/912
					capabilities = {
						textDocument = {
							foldingRange = {
								dynamicRegistration = false,
								lineFoldingOnly = true,
							},
						},
					},
					settings = {
						yaml = {
							schemaStore = {
								-- You must disable built-in schemaStore support if you want to use
								-- this plugin and its advanced options like `ignore`.
								enable = false,
								-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},
				marksman = {},
				cssls = {},
				pyright = {
					capabilities = {
						documentFormattingProvider = false,
					},
					settings = {
						pyright = {
							-- Using Ruff's import organizer
							disableOrganizeImports = true,
						},
						python = {
							analysis = {
								-- Ignore all files for analysis to exclusively use Ruff for linting
								ignore = { "*" },
							},
						},
					},
				},
				ruff = {},
			}

			-- setup mason
			require("mason").setup({
				log_level = vim.log.levels.INFO,
			})

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"biome",
				-- INFO: no need to add the below line, as system installed rust-analyzer shall be picked up
				-- see ../../README.md for more info on setting up rust-analyzer on host
				-- "rust_analyzer",
			})

			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local function opts(desc)
						return { buffer = ev.buf, desc = "LSP: " .. desc }
					end

					local tsBuiltin = require("telescope.builtin")

					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to [d]eclaration"))
					vim.keymap.set("n", "gd", tsBuiltin.lsp_definitions, opts("Go to [d]efination"))
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Show hover documentation"))
					vim.keymap.set("n", "gi", tsBuiltin.lsp_implementations, opts("Go to [i]mplementation"))
					vim.keymap.set("n", "gr", tsBuiltin.lsp_references, opts("Go to [r]eferences"))

					vim.keymap.set({ "n", "v" }, "<leader>ac", function()
						if vim.bo.filetype == "rust" then
							vim.cmd.RustLsp("codeAction")
						else
							vim.lsp.buf.code_action()
						end
					end, opts("Show [C]ode actions"))
					vim.keymap.set("n", "<leader>D", tsBuiltin.lsp_type_definitions, opts("Type [D]definition"))
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("[R]e[n]ame"))
					vim.keymap.set("n", "<leader>fd", tsBuiltin.lsp_document_symbols, opts("Find [d]ocument symbols"))
					vim.keymap.set(
						"n",
						"<leader>fr",
						tsBuiltin.lsp_dynamic_workspace_symbols,
						opts("find dynamic workspace symbols")
					)
				end,
			})

			-- toggle lsp inlay_hints keymap if lsp supports it, otherwise this shall throw error
			vim.keymap.set("n", "<leader>th", function()
				if vim.lsp.inlay_hint == nil then
					print("Error: inlay hints not supported by LSP")
					return
				end

				-- toggle inlay hints
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
			end, { desc = "Toggle inlay [h]ints" })

			-- enable inlayhints by default if lsp supports it, enabling it might cause unusual errors
			-- vim.api.nvim_create_autocmd("LspAttach", {
			-- 	group = vim.api.nvim_create_augroup("LspAttach_inlayhints", { clear = true }),
			-- 	pattern = { "*.lua", "*.rs", "*.go" },
			-- 	callback = function(event)
			-- 		if vim.lsp.inlay_hint == nil then
			-- 			return ""
			-- 		end
			--
			-- 		pcall(vim.lsp.inlay_hint.enable, true, { bufnr = event.buf })
			-- 	end,
			-- })
		end,
	},
}
