vim.pack.add({
	{
		src = "https://github.com/rmagatti/auto-session",
		name = "auto-session",
	},
}, { load = true })

local auto_session = require("auto-session")

auto_session.setup({
	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
	log_level = "error",
	git_use_branch_name = true,
	enabled = true,
})

vim.api.nvim_create_user_command("Restart", function()
	auto_session.SaveSession()
	vim.cmd("restart")
end, {})
