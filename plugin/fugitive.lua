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
