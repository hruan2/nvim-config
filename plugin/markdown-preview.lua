vim.pack.add({
	{
		src = "https://github.com/selimacerbas/markdown-preview.nvim",
		name = "markdown_preview",
	},
	{
		src = "https://github.com/selimacerbas/live-server.nvim",
		name = "live_server",
	},
})

require("live_server").setup({
	default_port = 8000,
	live_reload = {
		enabled = true,
		inject_script = true,
		debounce = 120,
		css_inject = true,
	},
	directory_listing = {
		enabled = true,
		show_hidden = false,
	},
})

require("markdown_preview").setup({
	-- all optional; sane defaults shown
	instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
	port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
	host = "0.0.0.0",
	open_browser = false,
	default_theme = "dark", -- "dark" or "light"; initial preview theme
	debounce_ms = 300,
	mermaid_renderer = "rust",
	hooks = {
		-- to allow use over ssh
		on_start = function(url)
			vim.notify("Markdown Preview: " .. url, vim.log.levels.INFO)
		end,

		on_stop = function()
			vim.notify("Markdown Preview stopped", vim.log.levels.INFO)
		end,
	},
})

vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Markdown: Start preview" })
vim.keymap.set("n", "<leader>mps", "<cmd>MarkdownPreviewStop<cr>", { desc = "Markdown: Stop preview" })
vim.keymap.set("n", "<leader>mpr", "<cmd>MarkdownPreviewRefresh<cr>", { desc = "Markdown: Refresh preview" })
