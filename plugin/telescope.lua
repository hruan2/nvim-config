-- autocommand to automatically compile the relevant library on installation
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("pack-changed", { clear = false }),
	callback = function(ev)
		local plugin_name = ev.data.spec.name
		local action = ev.data.kind

		if not ev.data.active then
			vim.cmd("packadd " .. plugin_name)
		end

		if
			plugin_name == "telescope-fzf-native.nvim"
			and (action == "install" or action == "update")
		then
			vim.system({ "make", "clean" }, { cwd = ev.data.path }):wait()
			local res = vim.system({ "make" }, { cwd = ev.data.path }):wait()

			if vim.v.shell_error ~= 0 then
				vim.notify(
					"failed to compile telescope-fzf-native: " .. res,
					vim.log.levels.ERROR
				)
			else
				vim.notify(
					"succesfully compiled telescope-fzf-native",
					vim.log.levels.INFO
				)
			end
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
})

local telescope = require("telescope")
telescope.setup({})
require("nvim-web-devicons").setup()

telescope.load_extension("live_grep_args")
telescope.load_extension("fzf")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>pa", function()
	builtin.find_files({ no_ignore = true, hidden = true })
end, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})

vim.keymap.set(
	"n",
	"<leader>pg",
	builtin.grep_string,
	{ desc = "telescope grep string" }
)
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "telescope grep string with search" })

vim.keymap.set(
	"n",
	"<leader>lg",
	builtin.live_grep,
	{ desc = "telescope live grep" }
)
vim.keymap.set("n", "<leader>ls", function()
	builtin.live_grep(
		{ search = vim.fn.input("Live grep > ") },
		{ desc = "telescope live grep with search " }
	)
end)

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
				vim.keymap.set("n", "gd", builtin.lsp_definitions, {
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
