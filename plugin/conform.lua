vim.pack.add({
	{
		src = "https://github.com/stevearc/conform.nvim",
		name = "conform",
	},
})

local conform = require("conform")

-- Filetypes whose formatter is slow to start (Node tools on NFS). These format
-- after the save in the background instead of blocking the save.
local slow_filetypes = { markdown = true }

conform.setup({
	notify_on_error = true,
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = {}

		local filetype = vim.bo[bufnr].filetype

		if disable_filetypes[filetype] or slow_filetypes[filetype] then
			return nil
		end

		return { timeout_ms = 2000 }
	end,

	format_after_save = function(bufnr)
		if not slow_filetypes[vim.bo[bufnr].filetype] then
			return nil
		end

		return { lsp_format = "fallback" }
	end,

	default_format_opts = {
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		c = { "clang_format" },
		cpp = { "clang_format" },
		go = { "gofmt", "goimports" },
		html = { "djlint" },
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		lua = { "stylua" },
		markdown = { "prettierd" },
		rust = { "rustfmt" },
		sh = { "shfmt" },
		tex = { "latexindent" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
	},
	formatters = {
		clang_format = {
			prepend_args = { "--style=file", "--fallback-style=Google" },
		},

		latexindent = {
			prepend_args = { "-l", "-m", "-r" },
		},

		-- prettierd ignores command-line options. This config applies only
		-- when the project has no Prettier config file of its own.
		prettierd = {
			env = {
				PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config")
					.. "/prettierrc.json",
			},
		},
	},
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	conform.format({ async = true })
end, { desc = "format buffer" })
