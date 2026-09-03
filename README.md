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

## to freshly delete and reinstall all vim.pack plugins:
1. ```cd ~/.local/share/nvim/site/pack```
2. ```rm -rf core``` (or all the plugin directories)

## TODO
- [X] get copy and paste working on ghostty with tmux over ssh
    - use shift key to highlight text to local clipboard
- [ ] double check interaction between mason and lsp lua files
- [ ] look at lua_ls bug that causes nvim config editing to be really slow
- [ ] add and/or update descriptions of various mappings
