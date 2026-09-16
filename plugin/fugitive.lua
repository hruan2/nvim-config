vim.pack.add({
	{
		src = "https://github.com/tpope/vim-fugitive",
		name = "vim-fugitive",
	},
})

local toggle_fugitive = function()
	local winids = vim.api.nvim_list_wins()
	for _, id in pairs(winids) do
		local status = pcall(vim.api.nvim_win_get_var, id, "fugitive_status")

		if status then
			vim.api.nvim_win_close(id, false)
			return
		end
	end

	vim.cmd("Git")
end

vim.keymap.set(
	"n",
	"<leader>gs",
	toggle_fugitive,
	{ silent = true, desc = "toggle git status" }
)

vim.keymap.set(
	"n",
	"<leader>gd",
	"<cmd>Gvdiffsplit!<CR>",
	{ desc = "Fugitive open git vertical split" }
)

vim.keymap.set(
	"n",
	"<leader>gdh",
	"<cmd>diffget //2<CR>",
	{ desc = "Fugitive pull from left (usually target)" }
)
vim.keymap.set(
	"n",
	"<leader>gdl",
	"<cmd>diffget //3<CR>",
	{ desc = "Fugitive pull from right (usually to be merged branch)" }
)
