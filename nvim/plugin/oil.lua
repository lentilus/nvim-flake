if vim.g.did_load_oil_plugin then
  return
end
vim.g.did_load_oil_plugin = true

local opts = {
  view_options = {
    show_hidden = true,
  },
  skip_confirm_for_simple_edits = true,
}

require('oil').setup(opts)
vim.keymap.set('n', '-', vim.cmd.Oil, { desc = 'Open parent directory' })
