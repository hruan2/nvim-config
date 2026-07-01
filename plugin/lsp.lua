vim.pack.add({
    {
        src = 'https://github.com/neovim/nvim-lspconfig',
        version = vim.version.range('*'),
        name = 'lspconfig'
    }
    },
    { load = true })


local cmp_lsp = require('cmp_nvim_lsp')
local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)

vim.lsp.config('*', {
    capabilities = capabilities,
})

local lsp_servers = {
    'basedpyright',
    'bashls',
    'clangd',
    'jsonls',
    'lua_ls',
    'ruff',
    'rust_analyzer',
    'texlab',
    -- 'gopls',
    -- 'vtsls',
    -- 'tailwindcss',
}

vim.lsp.enable(lsp_servers)

-- Enable codelens globally
vim.lsp.codelens.enable(true)

vim.diagnostic.config({
    -- update_in_insert = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = true,
        header = '',
        prefix = '',
    },
    -- virtual_text = true,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buf = args.buf

        if client then
            -- Disable codelens for lua (lua_ls '0 References' is noisy)
            if client.name == 'lua_ls' then
                vim.lsp.codelens.enable(false, { bufnr = buf })
            end

            -- LSP folding (override treesitter default from init.lua)
            if client:supports_method('textDocument/foldingRange', buf) then
                require('fold').lsp_foldexpr(vim.api.nvim_get_current_win())
            end

            -- Workspace diagnostics
            if client:supports_method('workspace/diagnostic', buf) then
                vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
            end
            -- else
            --     if Config.use_workspace_diagnostics_plugin then
            --         require('workspace-diagnostics').populate_workspace_diagnostics(client, buf)
            --     end
            -- end

            -- Inline completion
            if client:supports_method('textDocument/inlineCompletion', buf) then
                vim.lsp.inline_completion.enable(true)
            end

            -- Linked editing (e.g., paired HTML tags)
            if client:supports_method('textDocument/linkedEditingRange', buf) then
                vim.lsp.linked_editing_range.enable(true, { bufnr = buf })
            end

            -- Inline color swatches
            if client:supports_method('textDocument/documentColor', buf) then
                vim.lsp.document_color.enable(true, { bufnr = buf })
            end

            if client:supports_method('textDocument/declaration', buf) then
                vim.api.nvim_buf_set_keymap(buf, 'n', "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
            end

            if client:supports_method('textDocument/definition', buf) then
                vim.api.nvim_buf_set_keymap(buf, 'n', "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
            end

            -- Format on typing trigger characters
            -- NOTE: I think I rather use conform.nvim as otherwise this yields unexpected results.
            -- if client:supports_method('textDocument/onTypeFormatting', buf) then
            --   vim.lsp.on_type_formatting.enable(true, { bufnr = buf })
            -- end
        end

        -- Keymaps
        -- LSP keymaps not covered by snacks picker (gd, gD, gr, gI, gt are in snacks.lua)
        -- hover text description if available
        vim.keymap.set('n', "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover" })

        -- get func signature while in insert mode
        vim.keymap.set('i', "<c-s>", function() vim.lsp.buf.signature_help() end, {buffer = true})

        -- vim.keymap.set('n', "<leader>cr", vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
        -- vim.keymap.set('n', "<leader>cR", Snacks.rename.rename_file, { buffer = buf, desc = "Rename file" })

        -- code action?
        vim.keymap.set({ 'n', "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code action" })
        vim.keymap.set('n', "<leader>cc", vim.lsp.codelens.run, { buffer = buf, desc = "Run codelens" })
        vim.keymap.set({ 'n', "x" }, "<M-o>", function()
            vim.lsp.buf.selection_range(1)
        end, { buffer = buf, desc = 'Expand selection (LSP)' })
        vim.keymap.set('x', "<M-i>", function()
            vim.lsp.buf.selection_range(-1)
        end, { buffer = buf, desc = 'Shrink selection (LSP)' })
        vim.keymap.set('n', "<leader>uh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
        end, { buffer = buf, desc = 'Toggle inlay hints' })
        vim.keymap.set('n', "<leader>ul", function()
            local enabled = not vim.lsp.codelens.is_enabled()
            vim.lsp.codelens.enable(enabled)
            vim.notify('Codelens: ' .. (enabled and "on" or "off"))
        end, { buffer = buf, desc = 'Toggle codelens' })
        vim.keymap.set('n', "[d", function()
            vim.diagnostic.jump({ count = -1 })
        end, { buffer = buf, desc = 'Prev diagnostic' })
        vim.keymap.set('n', "]d", function()
            vim.diagnostic.jump({ count = 1 })
        end, { buffer = buf, desc = 'Next diagnostic' })
    end,
})

-- Reset diagnostics on detach so :lsp restart/:lsp stop don't leave stale state.
vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('lsp-detach-cleanup', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        local prefix = ('nvim.lsp.%s.%d'):format(client.name, client.id)
        for namespace, metadata in pairs(vim.diagnostic.get_namespaces()) do
            local name = metadata.name or ''
            if name == prefix or vim.startswith(name, prefix .. '.') then
                vim.diagnostic.reset(namespace)
            end
        end
    end,
})
