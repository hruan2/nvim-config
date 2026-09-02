vim.pack.add({
	{
		src = "https://github.com/rcarriga/nvim-dap-ui",
		name = "dapui",
	},
	{
		src = "https://github.com/nvim-neotest/nvim-nio",
		name = "nvim-nio",
	},
	{
		src = "https://github.com/thehamsta/nvim-dap-virtual-text",
		name = "nvim-dap-virtual-text",
	},
	{
		src = "https://github.com/mfussenegger/nvim-dap",
		name = "dap",
	},
})

require("nvim-dap-virtual-text").setup()

local dap = require("dap")
dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = {
		"--quiet",
		"--interpreter=dap",
		"--eval-command",
		"set pretty print on",
	},
}

dap.configurations.c = {
	{
		name = "Run executable (GDB)",
		type = "gdb",
		request = "launch",
		program = function()
			local path = vim.fn.input({
				prompt = "Path to executable: ",
				default = vim.fn.getcwd() .. "/",
				completion = "file",
			})

			return (path and path ~= "") and path or dap.ABORT
		end,
	},
	{
		name = "Run executable (GDB)",
		type = "gdb",
		request = "launch",
		program = function()
			local path = vim.fn.input({
				prompt = "Path to executable: ",
				default = vim.fn.getcwd() .. "/",
				completion = "file",
			})

			return (path and path ~= "") and path or dap.ABORT
		end,

		args = function()
			local args_str = vim.fn.input({
				prompt = "Arguments: ",
			})
			return vim.split(args_str, " +")
		end,
	},
	{
		name = "Attach to process (GDB)",
		type = "gdb",
		request = "attach",
		processId = require("dap.utils").pick_process,
		args = {},
	},
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

local ui = require("dapui")

ui.setup()

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end

vim.keymap.set({ "n" }, "<leader>db", function()
	dap.toggle_breakpoint()
end, { nowait = true, remap = false })
vim.keymap.set({ "n" }, "<leader>dc", function()
	dap.continue()
end, { nowait = true, remap = false })
vim.keymap.set({ "n" }, "<leader>dq", function()
	dap.terminate()
	ui.close()
	require("nvim-dap-virtual-text").toggle()
end, { nowait = true, remap = false })
vim.keymap.set({ "n" }, "<leader>di", function()
	dap.step_into()
end, { nowait = true, remap = false })
