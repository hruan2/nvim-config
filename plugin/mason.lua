vim.pack.add({
	{
		src = "https://github.com/mason-org/mason.nvim",
		name = "mason",
	},
	{
		src = "https://github.com/mason-org/mason-lspconfig.nvim",
		name = "mason-lspconfig",
	},
})

require("mason").setup()

local ensure_installed = vim.tbl_keys(Lsp_servers or {})
vim.list_extend(ensure_installed, {
	clang_format = {},
	latexindent = {},
})

require("mason-lspconfig").setup({
	ensure_installed = ensure_installed,
	automatc_enable = true,
})
