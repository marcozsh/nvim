vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--prittier
vim.keymap.set("n", "<Leader>py", function()
  local save_pos = vim.fn.getpos(".")
  vim.cmd("silent %!prettier --stdin-filepath %")
  vim.fn.setpos(".", save_pos)
  vim.cmd("normal! zz")
end, { silent = true })


--navigation (bufferline)
vim.keymap.set("n", "na", ":BufferLineCycleNext<CR>", { silent = true })  -- Siguiente buffer
vim.keymap.set("n", "nc", ":bdelete<CR>", { silent = true })  -- Cerrar buffer actual

-- Atajos antiguos (por compatibilidad)
vim.keymap.set("n", "ba", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "bb", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "cb", ":bd<CR>", { silent = true })

--nerdtree (DESACTIVADO - usando nvim-tree)
-- vim.keymap.set("n", "nt", ":NERDTreeToggle<CR>")

--nvim-tree
vim.keymap.set("n", "nt", ":NvimTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "nf", ":NvimTreeFindFile<CR>", { silent = true })

--lazygit
vim.keymap.set("n", "<Leader>gg", ":LazyGit<CR>")

--termtoogle
vim.keymap.set("n", "<Leader>te", ":ToggleTerm<CR>", { desc = "Terminal"})

