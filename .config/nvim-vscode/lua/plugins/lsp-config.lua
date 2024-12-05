return {
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		cond = function ()
			return vim.g.vscode == nil
		end,
		event = "BufEnter",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

			local util = require("lspconfig/util")

			-- ts_ls setup
			local function organize_imports()
				local params = {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
				}
				vim.lsp.buf.execute_command(params)
			end

			local servers = {
				-- biome = {},
				ts_ls = {
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
					-- See https://dev.to/davidecavaliere/avoid-conflicts-between-denols-and-tsserver-in-neovim-4bco
					root_dir = function(filename, _bufnr)
						local denoRootDir = util.root_pattern("deno.json", "deno.jsonc")(filename)
						if denoRootDir then
							-- print('this seems to be a deno project; returning nil so that tsserver does not attach');
							return nil
						end

						-- else
						-- print('this seems to be a ts project; return root dir based on package.json')
						return util.root_pattern("package.json")(filename)
					end,
					single_file_support = false,
				},
				denols = {
					root_dir = util.root_pattern("deno.json", "deno.jsonc"),
					init_options = {
						enable = true,
						lint = true,
						unstable = true,
						suggest = {
							imports = {
								hosts = {
									["https://deno.land"] = true,
									-- ["https://cdn.nest.land"] = true,
									-- ["https://crux.land"] = true,
								},
							},
						},
					},
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
				emmet_language_server = {},
				tailwindcss = {
					settings = {
						includeLanguages = {
							templ = "html",
						},
					},
				},
				templ = {},
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
				-- TOML
				taplo = {
					settings = {
						taplo = {
							schema = {
								enabled = true, -- Enable schema validation for TOML
								repositoryEnabled = true, -- Enable schema repository from SchemaStore
								cache = true,
							},
							lint = {
								enabled = true, -- Enable linting
							},
							format = {
								enabled = true, -- Enable formatting
								command = "taplo fmt", -- Taplo formatter
							},
						},
					},
				},
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
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
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

					-- local tsBuiltin = require("telescope.builtin")

					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Show hover documentation"))
					-- vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts("Go to [d]eclaration"))

					-- vim.keymap.set("n", "<leader>vgd", vim.lsp.buf.definition, opts("Go to [d]efination"))
					-- vim.keymap.set("n", "<leader>vgi", vim.lsp.buf.implementation, opts("Go to [i]mplementation"))
					-- vim.keymap.set("n", "<leader>vgr", vim.lsp.buf.references, opts("Go to [r]eferences"))
					-- vim.keymap.set("n", "<leader>vgt", vim.lsp.buf.type_definition, opts("Type [D]definition"))
					-- vim.keymap.set("n", "<leader>vgs", vim.lsp.buf.document_symbol, opts("Find [d]ocument symbols"))

					-- vim.keymap.set("n", "<leader>gd", tsBuiltin.lsp_definitions, opts("Go to [d]efination"))
					-- vim.keymap.set("n", "<leader>gi", tsBuiltin.lsp_implementations, opts("Go to [i]mplementation"))
					-- vim.keymap.set("n", "<leader>gr", tsBuiltin.lsp_references, opts("Go to [r]eferences"))
					-- vim.keymap.set("n", "<leader>gt", tsBuiltin.lsp_type_definitions, opts("Type [D]definition"))
					-- vim.keymap.set("n", "<leader>gs", tsBuiltin.lsp_document_symbols, opts("Find [d]ocument symbols"))

					-- vim.keymap.set({ "n", "v" }, "<leader>ac", function()
					-- 	if vim.bo.filetype == "rust" then
					-- 		vim.cmd.RustLsp("codeAction")
					-- 	else
					-- 		vim.lsp.buf.code_action()
					-- 	end
					-- end, opts("Show [C]ode actions"))
					vim.keymap.set("n", "<leader>rs", vim.lsp.buf.rename, opts("[s]ymbol/variable"))
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
