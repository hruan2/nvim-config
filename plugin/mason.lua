vim.pack.add({
	{
		src = "https://github.com/mason-org/mason.nvim",
		name = "mason",
	},
	{
		src = "https://github.com/mason-org/mason-lspconfig.nvim",
		name = "mason-lspconfig",
	},
	-- {
	-- 	src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	-- 	name = "mason-tool-installer",
	-- },
})

require("mason").setup()

-- this might be broken
local ensure_installed = vim.tbl_keys(Lsp_servers or {})
vim.list_extend(ensure_installed, {
	clang_format = {},
	latexindent = {},
})

require("mason-lspconfig").setup({
	ensure_installed = ensure_installed,
	automatc_enable = true,
})

-- local formatters = {
-- 	prettier = {},
-- 	shellcheck = {},
-- 	shfmt = {},
-- }
--
-- require("mason-tool-installer").setup({
-- 	ensure_installed = formatters,
-- 	run_on_start = true,
-- })
