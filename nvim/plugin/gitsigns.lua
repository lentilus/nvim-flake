if vim.g.did_load_gitsigns_plugin then
  return
end
vim.g.did_load_gitsigns_plugin = true

local opts = {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '-' },
    topdelete = { text = '-' },
    changedelete = { text = '~' },
    untracked = { text = '?' },
  },
  signs_staged = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '-' },
    topdelete = { text = '-' },
    changedelete = { text = '~' },
    untracked = { text = '?' },
  },
}

require('gitsigns').setup(opts)
