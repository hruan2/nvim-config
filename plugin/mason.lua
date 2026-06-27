vim.pack.add({
    {
        src = 'https://github.com/mason-org/mason.nvim',
        name = 'mason'
    },
    {
        src = 'https://github.com/mason-org/mason-lspconfig.nvim',
        name = 'mason-lspconfig',
    }
})

local ensure_installed = {
    "basedpyright",
    "bashls",
    "clangd",
    -- "jsonls",
    "ruff",
    "rust_analyzer",
    "texlab",
    "vimls",
}

require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = ensure_installed,
    automatic_enable = {
        exclude = {
            'texlab',
        }
    },
})
