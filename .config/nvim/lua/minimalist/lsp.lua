local enable_lsps  = require("minimalist.constants").enable_lsps

local enable       = function()
	for _, lsp in ipairs(enable_lsps) do
		vim.lsp.enable(lsp)
	end
end

local setup        = function()
	local lspconfig = require("lspconfig")

	local custom_setup = { "html", "cssls" }
	local simple_setup = require("minimalist.utils").filterTable(enable_lsps, custom_setup)

	-- Simple setup of servers
	for _, server in pairs(simple_setup) do
		local capabilities = require('blink.cmp').get_lsp_capabilities()
		lspconfig[server].setup({ capabilities = capabilities })
	end

	-- Custom setup of servers
	-- Snippet support required for css/html completions from vscode-langservers-extracted
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

	lspconfig.cssls.setup {
		capabilities = capabilities,
	}

	lspconfig.html.setup {
		capabilities = capabilities,
	}
end

return { enable = enable, setup = setup }
