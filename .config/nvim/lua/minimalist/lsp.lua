local M = {}

local enable_lsps = require("minimalist.constants").enable_lsps

function M.enable()
	for _, lsp in ipairs(enable_lsps) do
		vim.lsp.enable(lsp)
	end
end

local setup_lsps_with_sinippet_support = function()
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

local setup_svelte_lsp = function()
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

local setup_tailwindcss_lsp = function()
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

local setup_lua_ls = function()
	vim.lsp.config("lua_ls", {
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

function M.setup()
	local custom_setup = { "html", "cssls", "rust_analyzer", "svelte", "tailwindcss", "lua_ls" }
	local simple_setup = require("minimalist.utils").filterTable(enable_lsps, custom_setup)

	-- Simple setup of servers
	for _, server in pairs(simple_setup) do
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		vim.lsp.config(server, { capabilities = capabilities })
	end

	setup_lsps_with_sinippet_support()
	setup_svelte_lsp()
	setup_tailwindcss_lsp()
	setup_lua_ls()
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
