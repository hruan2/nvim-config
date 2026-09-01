vim.pack.add({
	{
		src = "https://github.com/toppair/peek.nvim",
		name = "peek",
	},
})

require("peek").setup({
	filetype = { "markdown", "conf" },
})

vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
