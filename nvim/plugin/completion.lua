if vim.g.did_load_completion_plugin then
  return
end
vim.g.did_load_completion_plugin = true

local opts = {
  keymap = { preset = 'default' },

  signature = { enabled = true },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
}

require('blink-cmp').setup(opts)
