-- Speed up locale initialization on Windows
vim.opt.langmenu = "en_US.UTF-8"

vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.numberwidth = 1
-- Lazy clipboard sync (faster startup)
vim.opt.clipboard = ""
vim.opt.encoding = "utf-8"
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.showmatch = true
vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.wrap = false
vim.opt.relativenumber = true
vim.opt.colorcolumn = "100"

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = "syntax on"
})

