vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

_G.Config = {
	use_treesitter_parser = true,
	use_nvim_treesitter = true,
}

require("set")
require("remap")
