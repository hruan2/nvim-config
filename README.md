experimental neovim config refactor using vim.pack (builtin neovim package manager)

stole some dotfiles and formatting ideas from: https://github.com/fredrikaverpil/dotfiles

to remove lazy.nvim stuff, remove the following directories:

1. ~/.local/share/nvim/lazy
2. ~/.local/state/nvim/lazy
3. ~/.config/nvim/lazy-lock.json

to update vim.pack plugins:
1. :packupdate
2. :write to update, :quit to not update

to delete vim.pack plugins:
1. remove relevant plugin/<name>.lua file
2. :packdel <plugin_name>...
