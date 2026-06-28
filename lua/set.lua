vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- Clear extraneous whitespace on saving file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function()
      local save_cursor = vim.fn.getpos(".")
      pcall(function() vim.cmd [[%s/\s\+$//e]] end)
      vim.fn.setpos(".", save_cursor)
    end,
})

-- Filetypes to enable spellcheck
local spell_types = { "text", "plaintex", "typst", "gitcommit", "markdown", "tex" }

-- Set global spell option to false initially to disable it for all file types
vim.opt.spell = false

-- Create an augroup for spellcheck to group related autocommands
vim.api.nvim_create_augroup("Spellcheck", { clear = true })

-- Create an autocommand to enable spellcheck for specified file types
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "Spellcheck", -- Grouping the command for easier management
  pattern = spell_types, -- Only apply to these file types
  callback = function()
    vim.opt_local.spell = true -- Enable spellcheck for these file types
    vim.opt_local.spelllang = "en_us"
  end,
  desc = "Enable spellcheck for defined filetypes", -- Description for clarity
})

-- Enable autoread and set up checking triggers
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = "*",
})
