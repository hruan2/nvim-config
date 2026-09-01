---@type vim.lsp.Config
return {
	cmd = {
		"clangd",
		"--clang-tidy",
		"--background-index",
		"--function-arg-placeholders=0",
		"--log=error",
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac", -- AutoTools
		".git",
	},
	get_language_id = function(_, ftype)
		local t = {
			objc = "objective-c",
			objcpp = "objective-cpp",
			cuda = "cuda-cpp",
		}
		return t[ftype] or ftype
	end,
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { "utf-8", "utf-16" },
	},
}
