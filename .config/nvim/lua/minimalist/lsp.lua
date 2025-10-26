local M = {}

local enable_lsps = require("minimalist.constants").enable_lsps

function M.enable()
	for _, lsp in ipairs(enable_lsps) do
		vim.lsp.enable(lsp)
	end
end

function M.setup()
	local lspconfig = require("lspconfig")

	local custom_setup = { "html", "cssls", "rust_analyzer" }
	local simple_setup = require("minimalist.utils").filterTable(enable_lsps, custom_setup)

	-- Simple setup of servers
	for _, server in pairs(simple_setup) do
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		vim.lsp.config(server, { capabilities = capabilities })
	end

	-- Custom setup of servers
	-- Snippet support required for css/html completions from vscode-langservers-extracted
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

	vim.lsp.config("cssls", { capabilities = capabilities })
	vim.lsp.config("html", { capabilities = capabilities })
end

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

return M
