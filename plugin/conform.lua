vim.pack.add({
	{
		src = "https://github.com/stevearc/conform.nvim",
		name = "conform",
	},
})

local conform = require("conform")

conform.setup({
	notify_on_error = true,
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local enable_filetypes = {
			lua = true,
			python = true,
			c = true,
		}
		local disable_filetypes = {}

		if enable_filetypes[vim.bo[bufnr].filetype] then
			return { timeout_ms = 500 }
		else
			return nil
		end
	end,

	default_format_opts = {
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		c = { "clang_format" },
		cpp = { "clang_format" },
		go = { "gofmt", "goimports" },
		html = { "djlint" },
		lua = { "stylua" },
		sh = { "shfmt" },
		tex = { "latexindent" },
	},
	formatters = {
		clang_format = {
			prepend_args = { "--style=file", "--fallback-style=Google" },
		},

		latexindent = {
			prepend_args = { "-l", "-m", "$FILENAME" },
		},
	},
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	conform.format({ async = true })
end, { desc = "format buffer" })
