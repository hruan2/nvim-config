vim.pack.add({
    {
        src = 'https://github.com/rmagatti/auto-session',
        name = 'auto-session',
    }
}, { load = true })

require("auto-session").setup({
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    log_level = 'error',
    git_use_branch_name = true,
    enabled = true,
})
