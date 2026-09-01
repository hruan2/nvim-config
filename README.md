# experimental neovim config refactor using vim.pack (builtin neovim package manager)

stole some dotfiles and formatting ideas from: https://github.com/fredrikaverpil/dotfiles

## to remove lazy.nvim stuff, remove the following files/directories:
1. ~/.local/share/nvim/lazy
2. ~/.local/state/nvim/lazy
3. ~/.config/nvim/lazy-lock.json

## to update vim.pack plugins:
1. ```:packupdate```
2. :w(rite) to update, :q(uit) to not update

## to delete vim.pack plugins:
1. remove relevant plugin/<name>.lua file
2. ```:packdel <plugin1> <plugin2> ...```

## TODO
- [ ] add and/or update descriptions of various mappings
- [ ] customize markview
- [ ] learn fugitive
