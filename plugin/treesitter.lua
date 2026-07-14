vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        if ev.data.spec.name == 'nvim-treesitter' then
            vim.cmd('TSUpdate')
        end
    end,
})

vim.pack.add({
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        version = 'main',
        name = 'nvim-treesitter'
    },
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
        name = 'nvim-treesitter-textobjects',
    },
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter-context',
        name = 'treesitter-context'
    },
})

-- Disable entire built-in ftplugin mappings to avoid conflicts.
vim.g.no_plugin_maps = true

local ts = require('nvim-treesitter')
local languages = {
    'asm',
    'bash',
    'c',
    'cpp',
    'dockerfile',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'git_config',
    'git_rebase',
    'go',
    'javascript',
    'jsdoc',
    'json',
    'json5',
    'latex',
    'linkerscript',
    'lua',
    'make',
    'nasm',
    'python',
    'regex',
    'rust',
    'sql',
    'typescript',
    'vimdoc',
}

ts.setup({})

ts.install(languages)

vim.api.nvim_create_autocmd('FileType', {
    pattern = languages,
    callback = function()
        -- Enable native Neovim treesitter highlighting
        vim.treesitter.start()

        -- Configure code folding
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = 'expr'
        vim.wo.foldlevel = 99

        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

require('treesitter-context').setup({
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false, -- Enable multiwindow support.
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20, -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
})

vim.filetype.add {
    extension = {
        x64 = "ld.x64",
        inc = "ld.inc",
    },
}
vim.treesitter.language.register('linkerscript', { 'ld.x64', 'ld.inc' })
