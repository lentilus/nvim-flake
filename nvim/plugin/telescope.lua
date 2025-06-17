if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope')
local builtin = require('telescope.builtin')

local function entry_maker(entry)
  local make_entry = require('telescope.make_entry')

  -- Use the default diagnostic entry maker as base
  local default_maker = make_entry.gen_from_lsp_symbols()
  local entry_tbl = default_maker(entry)

  -- Just modify the display to be simpler
  if entry_tbl then
    entry_tbl.display =
      string.format('(%s) %s ', vim.fn.fnamemodify(entry.filename or '', ':t'), entry.message or entry.text or '')
  end

  return entry_tbl
end

local opts = {
  defaults = {
    layout_strategy = 'vertical',
  },
  pickers = {
    find_files = { hidden = false },
    lsp_workspace_symbols = {
      symbol_width = 90,
      entry_maker = entry_maker,
    },
    lsp_dynamic_workspace_symbols = {
      symbol_width = 90,
      entry_maker = entry_maker,
    },
  },
}

telescope.setup(opts)
telescope.load_extension('git_worktree')

vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fv', builtin.git_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fb', builtin.buffers)
vim.keymap.set('n', '<leader>fh', builtin.help_tags)
vim.keymap.set('n', '<leader>fs', builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', '<leader>fw', function()
  vim.cmd.Telescope('git_worktree')
end)
