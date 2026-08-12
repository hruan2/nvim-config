vim.pack.add({
    {
        src = "https://github.com/f-person/git-blame.nvim",
        name = "gitblame",
    }
})

local git_blame = require("gitblame")
git_blame.setup {
    enabled = true,
    message_template = " <summary> || <date> || <author> || <<sha>>",
    date_format = "%m-%d-%Y %H:%M:%S",
    display_virtual_text = 1,
    schedule_event = "CursorHold",
    clear_event = "CursorHoldI",
}

vim.keymap.set("n", "<leader>gb", git_blame.toggle)
