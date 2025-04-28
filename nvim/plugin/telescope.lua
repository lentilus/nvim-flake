if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope')
local builtin = require('telescope.builtin')

local opts = {
  defaults = {
    layout_strategy = 'vertical',
  },
  pickers = {
    find_files = { hidden = false },
  },
}

telescope.setup(opts)
telescope.load_extension('git_worktree')

vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fv', builtin.git_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fb', builtin.buffers)
vim.keymap.set('n', '<leader>fh', builtin.help_tags)
vim.keymap.set('n', '<leader>fs', builtin.lsp_workspace_symbols)
vim.keymap.set('n', '<leader>fw', function()
  vim.cmd.Telescope('git_worktree')
end)
