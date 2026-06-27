vim.pack.add({
    {
        src = 'https://github.com/hrsh7th/nvim-cmp',
        name = 'cmp',
    },
    {
        src = 'https://github.com/hrsh7th/cmp-nvim-lsp',
        name = 'cmp-lsp',
    },
    {
        src = 'https://github.com/hrsh7th/cmp-buffer',
        name = 'cmp-buffer',
    },
    {
        src = 'https://github.com/hrsh7th/cmp-path',
        name = 'cmp-path',
    },
    {
        src = 'https://github.com/hrsh7th/cmp-cmdline',
        name = 'cmp-cmdline',
    },
    {
        src = 'https://github.com/saadparwaiz1/cmp_luasnip',
        name = 'cmp-luasnip',
    }
})

local cmp = require('cmp')
-- local cmp_lsp = require('cmp-lsp')
-- local capabilities = vim.tbl_deep_extend(
--     'force',
--     {},
--     vim.lsp.protocol.make_client_capabilities(),
--     cmp_lsp.default_capabilities()
-- )

local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
            elseif require('luasnip').expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
            else
                fallback()
            end
        end, {'i', 's'}),

        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'buffer' },
    })
})
