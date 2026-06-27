vim.pack.add({
    {
        src = 'https://github.com/lewis6991/gitsigns.nvim',
        name = 'gitsigns',
    }
    },
    { load = true })

require('gitsigns').setup()
