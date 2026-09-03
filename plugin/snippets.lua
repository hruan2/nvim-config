vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind
		if
			name == "LuaSnip"
			and vim.fn.has("win32") ~= 1
			and vim.fn.executable("make") == 1
			and (kind == "install" or kind == "update")
		then
			run_build(name, { "make", "install_jsregexp" }, ev.data.path)
		end
	end,
})

vim.pack.add({
	{
		src = "https://github.com/rafamadriz/friendly-snippets",
	},
	{
		src = "https://github.com/L3MON4D3/LuaSnip",
		name = "LuaSnip",
	},
})

local ls = require("luasnip")
ls.filetype_extend("javascript", { "jsdoc" })

vim.keymap.set({ "i" }, "<C-s>e", function()
	ls.expand()
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-s>;", function()
	ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-s>,", function()
	ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })
