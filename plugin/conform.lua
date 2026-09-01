vim.pack.add({
	{
		src = "https://github.com/stevearc/conform.nvim",
		name = "conform",
	},
})

require("conform").setup({
	notify_on_error = true,
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = {}
		return {
			timeout_ms = 2500,
			lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
		}
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		html = { "djlint" },
		go = { "gofmt", "goimports" },
		c = { "clang_format" },
		cpp = { "clang_format" },
	},
	formatters = {
		clang_format = {
			prepend_args = { "--style=file", "--fallback-style=Google" },
		},
	},
})
