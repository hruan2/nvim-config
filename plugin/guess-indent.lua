vim.pack.add({
	{
		src = "https://github.com/NMAC427/guess-indent.nvim",
		name = "guess-indent",
	},
})

require("guess-indent").setup()
