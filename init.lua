-- Speed optimizations for Windows
vim.env.LANG = 'en_US.UTF-8'
vim.env.LC_ALL = 'en_US.UTF-8'

-- Set <leader> BEFORE loading plugins (lazy.nvim uses it when creating keymaps)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("marcozsh")
