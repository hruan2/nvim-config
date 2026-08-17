-- if this plugin is not working, then double check that repository is "safe"
-- i.e. run "git blame" on its own in shell to check
-- if this is not the case, and the repository should be trusted, run the
-- command "git config --global --add safe.directory <directory>"
vim.pack.add({
    {
        src = "https://github.com/f-person/git-blame.nvim",
        name = "gitblame",
    }
})

local git_blame = require("gitblame")
git_blame.setup {
    enabled = false,
    message_template = " <summary> || <date> || <author> || <<sha>>",
    date_format = "%m-%d-%Y %H:%M:%S",
    display_virtual_text = 1,
    schedule_event = "CursorHold",
    clear_event = "CursorHoldI",
}

vim.keymap.set("n", "<leader>gb", git_blame.toggle)
