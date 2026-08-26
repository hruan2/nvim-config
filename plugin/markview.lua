vim.pack.add({
	{
		src = "https://github.com/OXY2DEV/markview.nvim",
		name = "markview",
	},
})

require("markview").setup({
	preview = {
		enable = false,
		icon_provider = "mini",
	},
})

vim.api.nvim_set_keymap(
	"n",
	"<leader>md",
	"<CMD>Markview splitToggle<CR>",
	{ desc = "Toggles `splitview` for current buffer." }
)
