vim.pack.add({
    {
        src = 'https://github.com/tpope/vim-fugitive',
        name = 'vim-fugitive',
    }
})

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
