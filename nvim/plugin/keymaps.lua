if vim.g.did_load_keymaps_plugin then
  return
end
vim.g.did_load_keymaps_plugin = true

local map = vim.keymap.set
local cmd = vim.cmd

-- quickfix
map('n', '<M-j>', cmd.cnext)
map('n', '<M-k>', cmd.cprevious)

-- tabs
map('n', '<M-h>', cmd.tabnext)
map('n', '<M-l>', cmd.tabprevious)

-- use letters as typed in select mode
map('s', 'h', '<BS>ih')
map('s', 'j', '<BS>ij')
map('s', 'k', '<BS>ik')
map('s', 'l', '<BS>il')

-- misc
map('n', '<leader>sm', cmd.messages)
map('n', '<leader>so', "<cmd>echo 'sourced file'<CR><cmd>source %<CR>")
map('n', '<ESC>', cmd.nohlsearch)
map('n', 'Y', 'y$', { silent = true, desc = '[Y]ank to end of line' })
