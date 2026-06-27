function ColorMyPencils(color)
	color = color or 'rose-pine-moon'
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, 'Normal', { bg = "none" })
	vim.api.nvim_set_hl(0, 'NormalFloat', { bg = "none" })
end

vim.pack.add({
    {
        src = 'https://github.com/rose-pine/neovim',
        name = 'rose-pine',
    },
})

require('rose-pine').setup({
    disable_background = true,
    styles = {
        italic = false,
    },
})

ColorMyPencils();
