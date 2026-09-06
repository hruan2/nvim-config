vim.pack.add({
	{
		src = "https://github.com/lervag/vimtex",
	},
}, { load = true })

local os_name = vim.loop.os_uname().sysname

-- skim for macos, zathura for linux
if os_name == "Darwin" then
	vim.g.vimtex_view_method = "skim"
elseif os_name == "Linux" then
	vim.g.vimtex_view_method = "zathura"
end
