vim.pack.add({
	{
		src = "https://github.com/nvim-telescope/telescope.nvim",
		name = "telescope",
	},
	{
		src = "https://github.com/nvim-lua/plenary.nvim",
		name = "plenary",
	},
	{
		src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	},
	{
		src = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim",
	},
})

require("telescope").setup({})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>pa", function()
	builtin.find_files({ no_ignore = true, hidden = true })
end, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})
vim.keymap.set("n", "<leader>reg", builtin.registers, {})
vim.keymap.set("n", "<leader>io", builtin.jumplist, {})
vim.keymap.set("n", "<leader>km", builtin.keymaps, {})

vim.keymap.set("n", "<leader>lr", builtin.lsp_references, {})
vim.keymap.set("n", "<leader>ea", builtin.diagnostics, {})
