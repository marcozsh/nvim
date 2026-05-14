vim.g.airline_theme = 'serene'
vim.g.airline_powerline_fonts = 1
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#left_sep'] = ' '
vim.g.airline_left_sep = ''
vim.g.airline_right_sep = ''
vim.g['airline#extensions#tabline#formatter'] = 'unique_tail'
vim.g['airline#extensions#coc#enabled'] = 0
vim.g['airline#extensions#whitespace#enabled'] = 0

local function AccentDemo()
  vim.g.airline_section_a = vim.fn['airline#section#create']({'mode'})
  vim.g.airline_section_b = vim.fn['airline#section#create']({'', ' ', 'filetype'})
  vim.g.airline_section_c = vim.fn['airline#section#create']({'branch'})
  vim.g.airline_section_z = vim.fn['airline#section#create']({' ', '%f'})
  vim.g.airline_section_y = vim.fn['airline#section#create']({' ', '%p'})

  local keys = {'m', 'a', 'r', 'c', 'o', 'z', 's', 'h'}
  for _, k in ipairs(keys) do
    vim.fn['airline#parts#define_text'](k, k)
  end

  local accents = {
    m = 'red', a = 'green', r = 'blue', c = 'yellow',
    o = 'red', z = 'blue', s = 'red', h = 'blue'
  }
  for k, color in pairs(accents) do
    vim.fn['airline#parts#define_accent'](k, color)
  end

  vim.g.airline_section_x = vim.fn['airline#section#create'](keys)
end

vim.api.nvim_create_autocmd('VimEnter', { callback = AccentDemo })
