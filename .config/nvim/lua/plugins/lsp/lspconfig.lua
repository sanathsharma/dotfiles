-- Clustered LSP domain module: nvim-lspconfig + lazydev + SchemaStore all
-- cooperate on the same concern (configuring language servers), plus the
-- generic on-attach behavior (keymaps, reference highlight, inlay hints).

local M = {}

-- Servers with no server-specific settings beyond default capabilities.
local enable_lsps = {
	"biome",
	"clangd",
	"css_variables",
	"cssls",
	"cssmodules_ls",
	"emmet_language_server",
	"html",
	"jsonls",
	"lua_ls",
	"marksman", -- markdown
	"stylelint_lsp",
	"svelte",
	"tailwindcss",
	"taplo", -- toml
	"ts_ls",
	"yamlls",
	-- "rust_analyzer", -- Managed by rustaceanvim
}

function M.enable()
	for _, lsp in ipairs(enable_lsps) do
		vim.lsp.enable(lsp)
	end
end

local function setup_lsps_with_snippet_support()
	-- Snippet support required for css/html completions from vscode-langservers-extracted
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

	vim.lsp.config("cssls", {
		capabilities = capabilities,
		settings = {
			css = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
			scss = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
			less = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
		},
	})
	vim.lsp.config("html", { capabilities = capabilities })
end

local function setup_svelte_lsp()
	local capabilities = require("blink.cmp").get_lsp_capabilities()
	vim.lsp.config("svelte", {
		capabilities = capabilities,
		settings = {
			svelte = {
				plugin = {
					svelte = {
						defaultScriptLanguage = "ts",
					},
				},
			},
		},
	})
end

local function setup_tailwindcss_lsp()
	local capabilities = require("blink.cmp").get_lsp_capabilities()
	vim.lsp.config("tailwindcss", {
		capabilities = capabilities,
		settings = {
			tailwindCSS = {
				classFunctions = { "cva", "cx", "clsx", "cn", "classNames" },
			},
		},
	})
end

local function setup_lua_ls()
	local capabilities = require("blink.cmp").get_lsp_capabilities()
	vim.lsp.config("lua_ls", {
		capabilities = capabilities,
		filetypes = { "lua" },
		settings = {
			Lua = {
				diagnostics = {
					disable = { "missing-fields" },
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
			},
		},
	})
end

local function setup_configuration_file_lsps()
	vim.lsp.config("jsonls", {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	})

	vim.lsp.config("yamlls", {
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
	})
end

local function setup_servers()
	local custom_setup = { "html", "cssls", "rust_analyzer", "svelte", "tailwindcss", "lua_ls", "yamlls", "jsonls" }
	local simple_setup = require("core.utils").filterTable(enable_lsps, custom_setup)

	-- Simple setup of servers
	for _, server in pairs(simple_setup) do
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		vim.lsp.config(server, { capabilities = capabilities })
	end

	setup_lsps_with_snippet_support()
	setup_svelte_lsp()
	setup_tailwindcss_lsp()
	setup_lua_ls()
	setup_configuration_file_lsps()
end

local function setup_keymaps()
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
	vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { desc = "Show docs for item under cursor" })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
	vim.keymap.set("n", "<M-i>", vim.lsp.buf.signature_help, { desc = "Show signature help" })

	vim.keymap.set("n", "<leader>ti", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, { desc = "Toggle lsp inlay hints" })

	vim.keymap.set("n", "<leader>td", function()
		local virtual_text_enabled = vim.diagnostic.config().virtual_text or false
		-- Toggle virtual_text: if nil/false, set to true, otherwise set to false
		vim.diagnostic.config({ virtual_text = not virtual_text_enabled, underline = true })

		require("fidget").notify("Diagnositics virtual text: " .. tostring(virtual_text_enabled), vim.log.levels.INFO)
	end, { desc = "Toggle diagnostics virtual text" })
end

local function setup_autocmds()
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local client_id = args.data.client_id
			local client = vim.lsp.get_client_by_id(client_id)
			if not client or not client.server_capabilities.executeCommandProvider then
				return
			end

			require("plugins.lsp.commands").setup(client)
		end,
	})

	-- ide like highlight when stopping cursor
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
		desc = "Highlight references under cursor",
		callback = function()
			-- Only run if the cursor is not in insert mode
			if vim.fn.mode() ~= "i" then
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				local supports_highlight = false
				for _, client in ipairs(clients) do
					if client.server_capabilities.documentHighlightProvider then
						supports_highlight = true
						break -- Found a supporting client, no need to check others
					end
				end

				-- Proceed only if an LSP is active AND supports the feature
				if supports_highlight then
					vim.lsp.buf.clear_references()
					vim.lsp.buf.document_highlight()
				end
			end
		end,
	})

	vim.api.nvim_create_autocmd("CursorMovedI", {
		group = "LspReferenceHighlight",
		desc = "Clear highlights when entering insert mode",
		callback = function()
			vim.lsp.buf.clear_references()
		end,
	})

	-- Manage inlay hints in insert mode.
	-- See https://github.com/neovim/neovim/discussions/29078
	vim.api.nvim_create_autocmd("InsertEnter", {
		desc = "Disable lsp.inlay_hint when in insert mode",
		callback = function(args)
			local filter = { bufnr = args.buf }
			local inlay_hint = vim.lsp.inlay_hint
			if inlay_hint.is_enabled(filter) then
				inlay_hint.enable(false, filter)
				vim.api.nvim_create_autocmd("InsertLeave", {
					once = true,
					desc = "Re-enable lsp.inlay_hint when leaving insert mode",
					callback = function()
						inlay_hint.enable(true, filter)
					end,
				})
			end
		end,
	})
end

function M.setup()
	setup_servers()
	setup_keymaps()
	setup_autocmds()
end

return M
