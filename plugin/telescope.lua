-- autocommand to automatically compile the relevant library on installation
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("pack-changed", { clear = false }),
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind
		local path = ev.data.path

		if
			name == "telescope-fzf-native.nvim"
			and (kind == "install" or kind == "update")
			and vim.fn.executable("make") == 1
		then
			run_build(name, { "make", "clean" }, path)
			run_build(name, { "make" }, path)
		end
	end,
})

vim.pack.add({
	{
		src = "https://github.com/nvim-lua/plenary.nvim",
		name = "plenary",
	},
	{
		src = "https://github.com/nvim-tree/nvim-web-devicons",
		name = "nvim-web-devicons",
	},
	{
		src = "https://github.com/nvim-telescope/telescope.nvim",
		name = "telescope",
	},
	{
		src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	},
	{
		src = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim",
	},
	{
		src = "https://github.com/nvim-telescope/telescope-ui-select.nvim",
	},
	{
		src = "https://github.com/nvim-telescope/telescope-file-browser.nvim",
	},
})

local telescope = require("telescope")
telescope.setup({})
require("nvim-web-devicons").setup()

telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
telescope.load_extension("ui-select")
telescope.load_extension("file_browser")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>pa", function()
	builtin.find_files({ no_ignore = true, hidden = true })
end, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<space>fb", function()
	telescope.extensions.file_browser.file_browser()
end, { desc = "telescope file browser" })

vim.keymap.set(
	"n",
	"<leader>pg",
	builtin.grep_string,
	{ desc = "telescope grep string" }
)
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "telescope grep string with search" })

-- disable these for now, as they don't work and need to do more research into
-- figuring out what live grep is and whether I should use it or not
vim.keymap.set(
	"n",
	"<leader>lg",
	builtin.live_grep,
	{ desc = "telescope live grep across all workspace files" }
)
vim.keymap.set("n", "<leader>/", function()
	builtin.live_grep({
		grep_open_files = true,
	})
end, { desc = "search for term in open files using live grep" })

vim.keymap.set(
	"n",
	"<leader>fg",
	":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
	{ desc = "telescope live grep with args" }
)

vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})
vim.keymap.set("n", "<leader>reg", builtin.registers, {})
vim.keymap.set("n", "<leader>io", builtin.jumplist, {})
vim.keymap.set("n", "<leader>ma", builtin.keymaps, {})

vim.keymap.set("n", "<leader>da", builtin.diagnostics, {})
vim.keymap.set("n", "z=", builtin.spell_suggest, {})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = false }),
	callback = function(args)
		vim.keymap.set("n", "<leader>lr", builtin.lsp_references, {})

		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local buf = args.buf

		if client then
			if client:supports_method("textDocument/definition", buf) then
				vim.keymap.set("n", "gd", function()
					builtin.lsp_definitions()
				end, {
					noremap = true,
					silent = true,
					desc = "lsp definitions telescope picker",
				})
			end

			if client:supports_method("textDocument/implementation", buf) then
				vim.keymap.set("n", "gi", builtin.lsp_implementations, {
					noremap = true,
					silent = true,
					desc = "lsp implementations telescope picker",
				})
			end
		end
	end,
})
