vim.pack.add({
    {
        src = 'https://github.com/stevearc/conform.nvim',
        name = 'conform',
    }
})

require('conform').setup({
    formatters_by_ft = {
    }
})
